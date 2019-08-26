import 'dart:io';

import 'package:source_gen_test/annotations.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/dio.dart' as dio;
import 'package:dio/dio.dart';

@ShouldGenerate(
  r'''
class _RestClient implements RestClient {
  _RestClient(this._dio) {
    ArgumentError.checkNotNull(_dio, '_dio');
  }

  final Dio _dio;
}
''',
)
@RestApi()
abstract class RestClient {}

@ShouldGenerate(r'''
 final String baseUrl = 'http://httpbin.org/';
}
''', contains: true)
@RestApi(baseUrl: "http://httpbin.org/")
abstract class BaseUrl {}

@ShouldGenerate(
  r'''
    const _extra = <String, dynamic>{};
''',
  contains: true,
)
@RestApi()
abstract class EmptyExtras {
  @GET('/list/')
  @dio.Extra({})
  Future<void> list();
}

@ShouldGenerate(
  r'''
    const _extra = <String, dynamic>{'key': 'value'};
''',
  contains: true,
)
@RestApi()
abstract class ExtrasWithPrimitiveValues {
  @GET('/list/')
  @dio.Extra({'key': 'value'})
  Future<void> list();
}

@ShouldGenerate(
  r'''
    const _extra = <String, dynamic>{'key': CustomConstant()};
''',
  contains: true,
)
@RestApi()
abstract class ExtrasWithCustomConstant {
  @GET('/list/')
  @dio.Extra({'key': CustomConstant()})
  Future<void> list();
}

class CustomConstant {
  const CustomConstant();
}

@ShouldGenerate(
  r'''
        options: RequestOptions(
            method: 'GET',
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class HttpGetTest {
  @GET("/get")
  Future<String> ip();
}

@ShouldGenerate(
  r'''
        options: RequestOptions(
            method: 'POST',
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class HttpPostTest {
  @POST("/post")
  Future<String> ip();
}

@ShouldGenerate(
  r'''
        options: RequestOptions(
            method: 'PUT',
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class HttpPutTest {
  @PUT("/put")
  Future<String> ip();
}

@ShouldGenerate(
  r'''
        options: RequestOptions(
            method: 'DELETE',
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class HttpDeleteTest {
  @DELETE("/delete")
  Future<String> ip();
}

@ShouldGenerate(
  r'''
        options: RequestOptions(
            method: 'PATCH',
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class HttpPatchTest {
  @PATCH("/delete")
  Future<String> ip();
}

@ShouldGenerate(
  r'''
contentType: ContentType.parse('application/x-www-form-urlencoded'),
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class FormUrlEncodedTest {
  @POST("/get")
  @FormUrlEncoded()
  Future<String> ip();
}

@ShouldGenerate(
  r'''
    final _data = FormData.from(<String, dynamic>{
      'image':
          UploadFileInfo(image, image.path.split(Platform.pathSeparator).last)
    });
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class FileFieldTest {
  @POST("/profile")
  Future<String> setProfile(@Field() File image);
}

@ShouldGenerate(
  r'''
    final _data = FormData.from(<String, dynamic>{
      'image': UploadFileInfo(image, 'my_profile_image.jpg')
    });
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class FileFieldWithCustomNameTest {
  @POST("/profile")
  Future<String> setProfile(@Field('image', 'my_profile_image.jpg') File image);
}

@ShouldGenerate(
  r'''
    final _data = FormData.from(<String, dynamic>{'image': image});
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class UploadFileInfoFieldTest {
  @POST("/profile")
  Future<String> setProfile(@Field() UploadFileInfo image);
}

@ShouldGenerate(
  r'''
    final value = User.fromJson(_result.data);
    return Future.value(value);
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class GenericCast {
  @POST("/users/1")
  Future<User> getUser();
}

class User {
  User();
  factory User.fromJson(Map<String, dynamic> json) {
    return User();
  }
  Map<String, dynamic> toJson() {
    return {};
  }
}

@ShouldGenerate(
  r'''
    final value = _result.data;
    return Future.value(value);
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class GenericCastBasicType {
  @POST("/users/1")
  Future<String> getUser();
}

@ShouldGenerate(
  r'''
    final _data = <String, dynamic>{};
    _data.addAll(user.toJson() ?? <String, dynamic>{});
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class TestObjectBody {
  @POST("/users")
  Future<String> createUser(@Body() User user);
}

@ShouldGenerate(
  r'''
    var value = _result.data.map((k, dynamic v) => MapEntry(
        k,
        (v as List)
            .map((i) => User.fromJson(i as Map<String, dynamic>))
            .toList()));

''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class TestMapBody {
  @GET("/xx")
  Future<Map<String, List<User>>> getResult();
}

@ShouldGenerate(
  r'''
    var value = _result.data.map((k, dynamic v) =>
        MapEntry(k, User.fromJson(v as Map<String, dynamic>)));
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class TestMapBody2 {
  @GET("/xx")
  Future<Map<String, User>> getResult();
}

@ShouldGenerate(
  r'''
    final value = _result.data;
    return Future.value(value);
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class TestBasicListString {
  @GET("/xx")
  Future<List<String>> getResult();
}

@ShouldGenerate(
  r'''
    final value = _result.data;
    return Future.value(value);
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class TestBasicListBool {
  @GET("/xx")
  Future<List<bool>> getResult();
}

@ShouldGenerate(
  r'''
    final value = _result.data;
    return Future.value(value);
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class TestBasicListInt {
  @GET("/xx")
  Future<List<int>> getResult();
}

@ShouldGenerate(
  r'''
    final value = _result.data;
    return Future.value(value);
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class TestBasicListDouble {
  @GET("/xx")
  Future<List<double>> getResult();
}
