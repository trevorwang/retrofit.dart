# Retrofit For Dart

[![CircleCI](https://circleci.com/gh/trevorwang/retrofit.dart.svg?style=svg)](https://circleci.com/gh/trevorwang/retrofit.dart)
[![Build Status](https://travis-ci.org/trevorwang/retrofit.dart.svg?branch=master)](https://travis-ci.org/trevorwang/retrofit.dart)

retrofit.dart is an [dio](https://github.com/flutterchina/dio/) client generator using [source_gen](https://github.com/dart-lang/source_gen) and inspired by [Chopper](https://github.com/lejard-h/chopper) and [Retrofit](https://github.com/square/retrofit).

## Usage

### Generator

Add the generator to your dev dependencies

```yaml
dependencies:
  retrofit:

dev_dependencies:
  retrofit_generator:
  build_runner:
```

### Define and Generate your API

```dart
import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';

part 'demo.retrofit.dart';

@RestApi(baseUrl: "https://httpbin.org/")
abstract class RestClient {
  factory RestClient(Dio dio) = _RestClient;

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

  /// Do not forget to add the appropriate headers
  @Headers({'Content-Type': 'multipart/form-data'})
  @POST("/profile")
  Future<Response<String>> setProfile(
      @Field('image', 'my_profile_image.jpg') File image);

  /// Do not forget to add the appropriate headers
  @Headers({'Content-Type': 'multipart/form-data'})
  @POST("/profile")
  /// This will add the image name from `image.path.split(Platform.pathSeperator).last`
  Future<Response<String>> setProfileImage(@Field() File image);

  /// Do not forget to add the appropriate headers
  @Headers({'Content-Type': 'multipart/form-data'})
  @POST("/profile")
  /// This will automatically work too.
  Future<Response<String>> setProfileImageWithInfo(@Field() UploadFileInfo image);
}
```

then run the generator

```sh
pub run build_runner build

#flutter
flutter packages pub run build_runner build
```

### Use it

```dart
import 'package:retrofit_example/demo.dart';
import 'package:dio/dio.dart';

main(List<String> args) {
  final dio = Dio();
  dio.options.headers["Demo-Header"] = "demo header";
  final client = RestClient.instance(dio);

  client.ip("trevor").then((it) => print(it));
}

```

### *NOTE*

> `retrofit.dart` will not automatically add `Content-Type` headers. Please use the `@Header` annotation for any required headers.
