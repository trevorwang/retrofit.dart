import 'package:dio/dio.dart' hide Headers;
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

part 'example.g.dart';

@RestApi(baseUrl: 'tasks')
abstract class TasksRestClient {
  factory TasksRestClient(
    Dio dio, {
    String? baseUrl,
    ParseErrorLogger? errorLogger,
  }) = _TasksRestClient;

  @GET('/tasks/{id}')
  Future<List<Task?>> getTaskById();

  @GET('/')
  Future<List<Task>> getTasks();

  @GET('/{id}')
  Future<Task> getTask(@Path('id') String id);

  @PATCH('/tasks/{id}')
  Future<Task> updateTaskPart(
    @Path() String id,
    @Body() Map<String, dynamic> map,
  );

  @PUT('/tasks/{id}')
  Future<Task> updateTask(@Path() String id, @Body() Task task);

  @DELETE('/tasks/{id}')
  Future<void> deleteTask(@Path() String id);

  @POST('/tasks')
  Future<Task> createTask(@Body() Task task);

  @POST('/tasks')
  Future<List<Task>> createTasks(@Body() List<Task> tasks);
}

@JsonSerializable()
class Task {
  const Task({
    required this.id,
    required this.name,
    required this.avatar,
    required this.createdAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  final String id;
  final String name;
  final String avatar;
  final String createdAt;

  Map<String, dynamic> toJson() => _$TaskToJson(this);
}

enum Status {
  @JsonValue('new')
  newValue,
  @JsonValue('on_going')
  onGoingValue,
  @JsonValue('closed')
  closedValue,
}

@JsonSerializable()
class TaskQuery {
  const TaskQuery(this.statuses);

  factory TaskQuery.fromJson(Map<String, dynamic> json) =>
      _$TaskQueryFromJson(json);

  final List<Status> statuses;

  Map<String, dynamic> toJson() => _$TaskQueryToJson(this);
}

@JsonSerializable()
class TaskGroup {
  const TaskGroup({
    required this.date,
    required this.todos,
    required this.completed,
    required this.inProgress,
  });

  factory TaskGroup.fromJson(Map<String, dynamic> json) =>
      _$TaskGroupFromJson(json);

  final DateTime date;
  final List<Task> todos;
  final List<Task> completed;
  final List<Task> inProgress;

  Map<String, dynamic> toJson() => _$TaskGroupToJson(this);
}

@JsonSerializable(genericArgumentFactories: true)
class ValueWrapper<T> {
  const ValueWrapper({required this.value});

  factory ValueWrapper.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ValueWrapperFromJson(json, fromJsonT);

  final T value;

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ValueWrapperToJson(this, toJsonT);
}
