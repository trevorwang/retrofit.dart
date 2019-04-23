import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';

part 'demo.g.dart';
part 'demo.retrofit.dart';

@RestApi(baseUrl: "https://httpbin.org/")
abstract class RestClient {
  static RestClient instance([Dio dio]) => _RestClient(dio);

  @GET("/get")
  @Headers({
    "Header-One": " header 1",
  })
  Future<Response<String>> ip(@Query('query1') String query,
      {@QueryMap() Map<String, dynamic> queryies,
      @Header("Header-Two") String header});

  @GET("/profile/{id}")
  Future<Response<String>> profile(@Path("id") String id,
      {@Query("role") String role = "user",
      @QueryMap() Map<String, dynamic> map = const {},
      @Body() Map<String, dynamic> map2});

  @POST("/post")
  @Headers({
    "Accept": "application/json",
  })
  Future<Response<String>> createProfile(@Query('query2') String query,
      {@QueryMap() Map<String, dynamic> queryies,
      @Header("Header-One") String header,
      @Body() Map<String, dynamic> map2,
      @Field() int field,
      @Field("field-g") String ffff});

  @PUT("/put")
  Future<Response<String>> updateProfile2(@Query('query3') String query,
      {@QueryMap() Map<String, dynamic> queryies,
      @Header("Header-One") String header,
      @Field() int field,
      @Field("field-g") String ffff});

  @PATCH("/patch")
  Future<Response<String>> updateProfile(@Query('query4') String query,
      {@QueryMap() Map<String, dynamic> queryies,
      @Field() int field,
      @Field("field-g") String ffff});
}

@JsonSerializable()
class Result {
  Map<String, dynamic> args;
  Map<String, dynamic> headers;
  String origin;
  String url;
  Result({this.args, this.headers, this.origin, this.url});

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);
}
