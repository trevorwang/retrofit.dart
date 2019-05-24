import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';

part 'demo.g.dart';

@RestApi(baseUrl: "https://httpbin.org/")
abstract class RestClient {
  factory RestClient([Dio dio]) = _RestClient;

  @GET("/get")
  @Headers({
    "Header-One": " header 1",
  })
  Future<Response<String>> ip(@Query('query1') String query,
      {@Queries() Map<String, dynamic> queryies,
      @Header("Header-Two") String header});

  @GET("/profile/{id}")
  Future<Response<String>> profile(@Path("id") String id,
      {@Query("role") String role = "user",
      @Queries() Map<String, dynamic> map = const {},
      @Body() Map<String, dynamic> map2});

  @POST("/post")
  @Headers({
    "Accept": "application/json",
  })
  Future<Response<String>> createProfile(@Query('query2') String query,
      {@Queries() Map<String, dynamic> queryies,
      @Header("Header-One") String header,
      @Body() Map<String, dynamic> map2,
      @Field() int field,
      @Field("field-g") String ffff});

  @PUT("/put")
  Future<Response<String>> updateProfile2(@Query('query3') String query,
      {@Queries() Map<String, dynamic> queryies,
      @Header("Header-One") String header,
      @Field() int field,
      @Field("field-g") String ffff});

  @PATCH("/patch")
  Future<Response<String>> updateProfile(@Query('query4') String query,
      {@Queries() Map<String, dynamic> queryies,
      @Field() int field,
      @Field("field-g") String ffff});
}
