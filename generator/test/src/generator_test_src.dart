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

@ShouldGenerate(r'''
class _HttpGetTest implements HttpGetTest {
  _HttpGetTest(this._dio) {
    ArgumentError.checkNotNull(_dio, '_dio');
    _dio.options.baseUrl = 'https://httpbin.org/';
  }

  final Dio _dio;

  @override
  ip() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    const _data = null;
    return _dio.request('/get',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: {}, extra: _extra),
        data: _data);
  }
}
''')
@RestApi(baseUrl: "https://httpbin.org/")
abstract class HttpGetTest {
  @GET("/get")
  Future<Response<String>> ip();
}

@ShouldGenerate(r'''
class _HttpPostTest implements HttpPostTest {
  _HttpPostTest(this._dio) {
    ArgumentError.checkNotNull(_dio, '_dio');
    _dio.options.baseUrl = 'https://httpbin.org/';
  }

  final Dio _dio;

  @override
  ip() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    const _data = null;
    return _dio.request('/post',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'POST', headers: {}, extra: _extra),
        data: _data);
  }
}
''')
@RestApi(baseUrl: "https://httpbin.org/")
abstract class HttpPostTest {
  @POST("/post")
  Future<Response<String>> ip();
}

@ShouldGenerate(r'''
class _HttpPutTest implements HttpPutTest {
  _HttpPutTest(this._dio) {
    ArgumentError.checkNotNull(_dio, '_dio');
    _dio.options.baseUrl = 'https://httpbin.org/';
  }

  final Dio _dio;

  @override
  ip() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    const _data = null;
    return _dio.request('/put',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'PUT', headers: {}, extra: _extra),
        data: _data);
  }
}
''')
@RestApi(baseUrl: "https://httpbin.org/")
abstract class HttpPutTest {
  @PUT("/put")
  Future<Response<String>> ip();
}

@ShouldGenerate(r'''
class _HttpDeleteTest implements HttpDeleteTest {
  _HttpDeleteTest(this._dio) {
    ArgumentError.checkNotNull(_dio, '_dio');
    _dio.options.baseUrl = 'https://httpbin.org/';
  }

  final Dio _dio;

  @override
  ip() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    const _data = null;
    return _dio.request('/delete',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'DELETE', headers: {}, extra: _extra),
        data: _data);
  }
}
''')
@RestApi(baseUrl: "https://httpbin.org/")
abstract class HttpDeleteTest {
  @DELETE("/delete")
  Future<Response<String>> ip();
}

@ShouldGenerate(r'''
class _HttpPatchTest implements HttpPatchTest {
  _HttpPatchTest(this._dio) {
    ArgumentError.checkNotNull(_dio, '_dio');
    _dio.options.baseUrl = 'https://httpbin.org/';
  }

  final Dio _dio;

  @override
  ip() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    const _data = null;
    return _dio.request('/delete',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'PATCH', headers: {}, extra: _extra),
        data: _data);
  }
}
''')
@RestApi(baseUrl: "https://httpbin.org/")
abstract class HttpPatchTest {
  @PATCH("/delete")
  Future<Response<String>> ip();
}
