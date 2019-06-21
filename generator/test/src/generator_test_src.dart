import 'package:source_gen_test/annotations.dart';
import 'package:retrofit/http.dart';

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
