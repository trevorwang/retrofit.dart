import 'dart:io';

import 'package:dio/dio.dart' as dio;
import '../http.dart';
import 'converter.dart';
import 'dart:async';
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
    options.responseType = dio.ResponseType.bytes;
    options.headers.addAll(newReq.headers);

    if (request.multipart) {
      var formdata = dio.FormData();
      for (var item in request.parts) {
        if (item.value is File) {
          formdata.files.add(MapEntry(item.name,
              dio.MultipartFile.fromBytes(item.value.readAsBytes())));
        } else {
          formdata.fields
              .add(MapEntry<String, String>(item.name, item.value.toString()));
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
    var contentType = response.headers['content-type'];
    if (converter == null &&
        (contentType?.contains('application/json') ?? false)) {
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
}
