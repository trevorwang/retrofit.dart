import 'package:source_gen_test/annotations.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/dio.dart' as dio;

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
