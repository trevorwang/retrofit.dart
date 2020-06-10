import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' hide Headers, Response;

part 'example.retrofit.dart';

@RestApi(baseUrl: "https://5d42a6e2bc64f90014a56ca0.mockapi.io/api/v1/")
abstract class RestClient extends Client {
  static RestClient create(Dio dio, {String baseUrl}) =>
      _RestClient(dio, baseUrl: baseUrl);

  @GET("/tasks")
  Future<List<String>> getTags();
}
