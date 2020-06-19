import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';

import '../http.dart';
import 'converter.dart';
import 'request.dart';
import 'response.dart';
import 'utils.dart';

class Client {
  final String baseUrl;
  dio.Dio _client;
  Converter converter;
  Client({
    this.baseUrl,
    dio.Dio dioClient,
    this.converter,
  }) : _client = dioClient ?? dio.Dio();

  Future<Response<T>> get<T, I>(
    String url, {
    Map<String, String> headers,
    Map<String, dynamic> parameters,
  }) =>
      request(Request(
        HttpMethod.GET,
        url,
        headers: headers,
        parameters: parameters,
      ));

  Future<Response<T>> post<T, I>(
    String url, {
    Map<String, String> headers,
    Map<String, dynamic> parameters,
    List<PartValue> parts,
    dynamic body,
  }) =>
      request<T, I>(Request(
        HttpMethod.POST,
        url,
        headers: headers,
        parameters: parameters,
        body: body,
        parts: parts,
        multipart: parts != null,
      ));

  Future<Response<T>> request<T, I>(Request request) async {
    var newReq = request;

    if (!isFormUrlEncoded(request)) {
      if (converter != null) {
        newReq = converter.convertRequest(request);
        assert(newReq != null);
      }
    }

    var body = newReq.body;
    final options = newReq.toRequest();
    options.baseUrl = this.baseUrl;
    // TODO: Will handle response type before release
    options.responseType = dio.ResponseType.bytes;
    options.headers.addAll(newReq.headers);

    if (request.multipart) {
      var formdata = dio.FormData();
      for (var item in request.parts) {
        final contentType = _fileContentType(item);
        if (item.value is dio.MultipartFile) {
          formdata.files.add(MapEntry(item.name, item.value));
        } else if (item.value is Iterable<dio.MultipartFile>) {
          final fileList = item.value as Iterable<dio.MultipartFile>;
          formdata.files.addAll(fileList.map((e) => MapEntry(item.name, e)));
        } else if (item.value is List<int>) {
          formdata.files.add(MapEntry(
            item.name,
            dio.MultipartFile.fromBytes(item.value, contentType: contentType),
          ));
        } else if (item.value is Iterable<List<int>>) {
          final bytesList = item.value as Iterable<List<int>>;
          formdata.files.addAll(bytesList.map((e) => MapEntry(
                item.name,
                dio.MultipartFile.fromBytes(e, contentType: contentType),
              )));
        } else if (item.value is File) {
          formdata.files.add(MapEntry(
              item.name,
              dio.MultipartFile.fromFileSync(item.value.path,
                  contentType: contentType)));
        } else {
          formdata.fields.add(MapEntry(item.name, item.value.toString()));
        }
      }

      body = formdata;
    }

    var res;
    try {
      res = await _client.requestUri(newReq.uri, data: body, options: options);
    } catch (err) {
      if (err is dio.DioError) {
        assert(err.response != null, 'unexpected http error!');
        res = err.response;
      } else {
        logger.warning('unexpected error happened!');
      }
    }
    var response = Response(res, res.data);
    var contentType = response.headers[contentTypeKey];
    if (converter == null && (contentType?.contains(jsonType) ?? false)) {
      converter = JsonConverter();
    }
    if (converter != null) {
      return response = converter.convertResponse<T, I>(response);
    }

    if (T is String || T == dynamic) {
      final data = String.fromCharCodes(response.body as List<int>);
      return response.copyWith(body: data as T);
    }
    return response;
  }

  MediaType _fileContentType(PartValue item) {
    if (item is PartFile) {
      final type = item.contentType;
      if (type != null) {
        return MediaType.parse(type);
      }
    }
    return null;
  }
}
