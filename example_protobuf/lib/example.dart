import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:flutter/foundation.dart';

import 'proto/query.pbserver.dart';

part 'example.g.dart';

@RestApi(baseUrl: "https://5d42a6e2bc64f90014a56ca0.mockapi.io/api/v1/")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("/tags")
  Future<Result> getProtoBufInt(@Body() Params message);

  
  @GET("/tags1")
  Future<List<int>> getMessage(@Body() Params message);
}
