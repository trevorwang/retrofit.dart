import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' hide Headers;
import 'json_mapper_example.reflectable.dart' show initializeReflectable;

part 'json_mapper_example.g.dart';

@RestApi(
  baseUrl: "https://5d42a6e2bc64f90014a56ca0.mockapi.io/api/v1/",
  parser: Parser.DartJsonMapper,
)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET("/tasks")
  Future<List<Task>> getTasks(@Query("dateTime") DateTime dateTime);
}

void main() {
  initializeReflectable();
}

@jsonSerializable
class Task {
  String id;
  String name;
  String avatar;
  String createdAt;

  Task({this.id, this.name, this.avatar, this.createdAt});
}
