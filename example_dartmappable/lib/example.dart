import 'package:dart_mappable/dart_mappable.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

part 'example.mapper.dart';
part 'example.g.dart';

@RestApi(
  baseUrl: 'https://5d42a6e2bc64f90014a56ca0.mockapi.io/api/v1/',
  parser: Parser.DartMappable,
)
abstract class ApiService {
  factory ApiService(
    Dio dio, {
    String? baseUrl,
    ParseErrorLogger? errorLogger,
  }) = _ApiService;

  @GET('/tasks')
  Future<List<Task>> getTasks();

  @GET('/tasks/{id}')
  Future<Task> getTask(@Path('id') String id);

  @POST('/tasks')
  Future<Task> createTask(@Body() Task task);

  @PUT('/tasks/{id}')
  Future<Task> updateTask(@Path() String id, @Body() Task task);

  @DELETE('/tasks/{id}')
  Future<void> deleteTask(@Path() String id);
}

@MappableClass()
class Task with TaskMappable {
  const Task({
    this.id,
    this.name,
    this.avatar,
    this.createdAt,
  });

  final String? id;
  final String? name;
  final String? avatar;
  final String? createdAt;
}
