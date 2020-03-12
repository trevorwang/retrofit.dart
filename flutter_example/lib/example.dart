import 'dart:convert';

import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:dio/src/headers.dart' as gg;

part 'example.g.dart';

@RestApi(baseUrl: "http://baidu.com")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;
  @GET('/tags')
  Future<List<String>> getTags({@DioOptions() options});
}

void test() {
  final dio = Dio();
  dio.interceptors.add(InterceptorsWrapper(onRequest: (options) {
    print(options.extra);
    print(options.baseUrl);
    print(options.method);
    print(options.headers);

    return dio.resolve(Response(
        data: jsonEncode([]),
        headers: gg.Headers()
          ..add("content-type", gg.Headers.jsonContentType)));
  }, onResponse: (i) {
    return jsonEncode(["hello", " world"]);
  }));
  final api = RestClient(dio);
  final options = buildCacheOptions(Duration(days: 7));
  dio.options.extra.addAll(options.extra);
  api.getTags().then(print).catchError(print);
}
