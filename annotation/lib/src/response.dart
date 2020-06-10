import 'package:dio/dio.dart' as dio;

class Response<T> {
  final dio.Response response;
  final T body;
  final dynamic error;

  Response(this.response, this.body, {this.error});

  int get status => this.response.statusCode;
  String get message => this.response.statusMessage;
  Map<String, String> get headers =>
      response.headers.map.map((key, value) => MapEntry(key, value.join(";")));

  Response<T> copyWith<T>({dio.Response response, T body}) =>
      Response(response ?? this.response, body ?? this.body);
}
