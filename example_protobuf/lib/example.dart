import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:retrofit_example/proto/params.pbserver.dart';
import 'package:retrofit_example/proto/result.pbserver.dart';

part 'example.g.dart';

@RestApi(baseUrl: 'https://5d42a6e2bc64f90014a56ca0.mockapi.io/api/v1/')
abstract class RestClient {
  factory RestClient(
    Dio dio, {
    String? baseUrl,
    ParseErrorLogger? errorLogger,
  }) = _RestClient;

  @POST('/tags')
  Future<Result> getProtoBufInt(@Body() Params message);

  @POST('/tags1')
  Future<List<int>> getMessage(@Body() Params message);
}
