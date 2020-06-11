import 'package:dio/dio.dart' as dio;
import 'converter.dart';
import 'dart:async';
import 'request.dart';
import 'response.dart';

class Client {
  final String baseUrl;
  dio.Dio _client;
  Converter converter;
  Client({
    this.baseUrl,
    dio.Dio dioClient,
    this.converter,
  }) : _client = dioClient ?? dio.Dio();

  Future<Response<T>> request<T, I>(Request request) async {
    var newReq = request;
    if (converter != null) {
      newReq = converter.convertRequest(request);
      assert(newReq != null);
    }

    final url = newReq.url;
    final _baseUrl = newReq.baseUrl ?? this.baseUrl;
    final body = newReq.body;
    final options = dio.RequestOptions(baseUrl: _baseUrl);
    options.method = newReq.method;
    options.responseType = dio.ResponseType.bytes;

    final res = await _client.request(url,
        data: body, queryParameters: request.parameters, options: options);

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
