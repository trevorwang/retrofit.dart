import 'dart:convert';

import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'example.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;
  @GET('/tags')
  Future<List<String>> getTags({@DioOptions() options});
}

void test() {
  final dio = Dio();
  dio.interceptors.add(InterceptorsWrapper(onRequest: (options) {
    print(options.extra);
  }, onResponse: (i) {
    return jsonEncode([]);
  }));
  final api = RestClient(dio);
  final options = buildCacheOptions(Duration(days: 7));
  dio.options.extra.addAll(options.extra);
  api.getTags().then(print).catchError(print);
}
