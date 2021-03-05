import 'mock_adapter.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' hide Headers;

part 'example.g.dart';

@RestApi(baseUrl: "http://baidu.com")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;
  @GET('/tags')
  Future<List<String>> getTags({@DioOptions() Options? options});
}

void test() {
  final dio = Dio();
  dio.httpClientAdapter = MockAdapter();

  dio.interceptors.add(InterceptorsWrapper(onRequest: (options) {
    print(options.extra);
    print(options.baseUrl);
    print(options.method);
    print(options.headers);
  }));
  final api = RestClient(dio, baseUrl: MockAdapter.mockBase);
  api.getTags().then((it) {
    print(it.length);
  });
}
