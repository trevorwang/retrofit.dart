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

@ShouldGenerate(
  r'''
class _BaseUrl implements BaseUrl {
  _BaseUrl(this._dio) {
    ArgumentError.checkNotNull(_dio, '_dio');
    _dio.options.baseUrl = 'http://httpbin.org/';
  }

  final Dio _dio;
}
''',
)
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
options: RequestOptions(method: 'GET', headers: {}, extra: _extra),
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class HttpGetTest {
  @GET("/get")
  Future<Response<String>> ip();
}

@ShouldGenerate(
  r'''
options: RequestOptions(method: 'POST', headers: {}, extra: _extra),
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class HttpPostTest {
  @POST("/post")
  Future<Response<String>> ip();
}

@ShouldGenerate(
  r'''
options: RequestOptions(method: 'PUT', headers: {}, extra: _extra),
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class HttpPutTest {
  @PUT("/put")
  Future<Response<String>> ip();
}

@ShouldGenerate(
  r'''
options: RequestOptions(method: 'DELETE', headers: {}, extra: _extra),
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class HttpDeleteTest {
  @DELETE("/delete")
  Future<Response<String>> ip();
}

@ShouldGenerate(
  r'''
options: RequestOptions(method: 'PATCH', headers: {}, extra: _extra),
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class HttpPatchTest {
  @PATCH("/delete")
  Future<Response<String>> ip();
}

@ShouldGenerate(
  r'''
            contentType:
                ContentType.parse('application/x-www-form-urlencoded')),
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class FormUrlEncodedTest {
  @POST("/get")
  @FormUrlEncoded()
  Future<Response<String>> ip();
}

@ShouldGenerate(
  r'''
    final _data = FormData.from({
      'image':
          UploadFileInfo(image, image.path.split(Platform.pathSeparator).last)
    });
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class FileFieldTest {
  @POST("/profile")
  Future<Response<String>> setProfile(@Field() File image);
}

@ShouldGenerate(
  r'''
    final _data =
        FormData.from({'image': UploadFileInfo(image, 'my_profile_image.jpg')});
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class FileFieldWithCustomNameTest {
  @POST("/profile")
  Future<Response<String>> setProfile(
      @Field('image', 'my_profile_image.jpg') File image);
}

@ShouldGenerate(
  r'''
    final _data = FormData.from({'image': image});
''',
  contains: true,
)
@RestApi(baseUrl: "https://httpbin.org/")
abstract class UploadFileInfoFieldTest {
  @POST("/profile")
  Future<Response<String>> setProfile(@Field() UploadFileInfo image);
}
