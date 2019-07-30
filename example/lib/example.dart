import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';
import 'package:retrofit_example/http_get.dart';

part 'example.g.dart';

@RestApi(baseUrl: "https://httpbin.org/")
abstract class RestClient {
  factory RestClient(Dio dio) = _RestClient;

  @GET("/get")
  @Headers({
    "Header-One": " header 1",
  })
  Future<HttpGet> ip(@Query('query1') String query,
      {@Queries() Map<String, dynamic> queryies,
      @Header("Header-Two") String header});

  @GET("/profile/{id}")
  Future<String> profile(@Path("id") String id,
      {@Query("role") String role = "user",
      @Queries() Map<String, dynamic> map = const {},
      @Body() Map<String, dynamic> map2});

  @POST("/post")
  @Headers({
    "Accept": "application/json",
  })
  Future<String> createProfile(@Query('query2') String query,
      {@Queries() Map<String, dynamic> queryies,
      @Header("Header-One") String header,
      @Body() Map<String, dynamic> map2,
      @Field() int field,
      @Field("field-g") String ffff});

  @PUT("/put")
  Future<String> updateProfile2(@Query('query3') String query,
      {@Queries() Map<String, dynamic> queryies,
      @Header("Header-One") String header,
      @Field() int field,
      @Field("field-g") String ffff});

  @PATCH("/patch")
  Future<String> updateProfile(@Query('query4') String query,
      {@Queries() Map<String, dynamic> queryies,
      @Field() int field,
      @Field("field-g") String ffff});

  @POST("/profile")
  Future<String> setProfile(@Field('image', 'my_profile_image.jpg') File image);

  /// This will add the image name from `image.path.split(Platform.pathSeperator).last`
  @POST("/profile")
  Future<String> setProfileImage(@Field() File image);

  /// This will automatically work too.
  @POST("/profile")
  Future<String> setProfileImageWithInfo(@Field() UploadFileInfo image);

  @POST("/users")
  Future<String> createUser(@Body() User user);

  @GET("/users")
  Future<Map<String, List<User>>> groupedUsers();
}

@JsonSerializable()
class User {
  User();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
