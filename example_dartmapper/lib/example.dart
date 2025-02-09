import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:http_parser/http_parser.dart' show MediaType;
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

part 'example.g.dart';

@RestApi(baseUrl: 'https://5d42a6e2bc64f90014a56ca0.mockapi.io/api/v1/')
abstract class RestClient {
  factory RestClient(
    Dio dio, {
    String? baseUrl,
    ParseErrorLogger? errorLogger,
  }) = _RestClient;

  @GET('/tags')
  Future<List<String>> getTags();

  @GET('/tags')
  Stream<List<String>> getTagsAsStream();

  @GET('/tasks')
  Future<List<Task>> getTasks();

  @GET('/tasks/{id}')
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

  @POST('http://httpbin.org/post')
  Future<void> createNewTaskFromFile(@Part() File file);

  @Headers(<String, String>{'accept': 'image/jpeg'})
  @GET('http://httpbin.org/image/jpeg')
  @DioResponseType(ResponseType.bytes)
  Future<List<int>> getFile();

  @POST('http://httpbin.org/post')
  @FormUrlEncoded()
  Future<String> postUrlEncodedFormData(
    @Field() String hello, {
    @Field() required String gg,
  });

  @HEAD('/')
  Future<String> headRequest();

  @HEAD('/')
  Future<void> headRquest2();

  @HEAD('/')
  Future<HttpResponse<dynamic>> headRquest3();

  @GET('/task/group')
  Future<List<TaskGroup>> grouppedTaskByDate();

  @GET('/task')
  Future<HttpResponse<List<Task>>> getTasksWithReponse();

  @DELETE('/tasks/{id}')
  Future<HttpResponse<void>> deleteTaskWithResponse(@Path() String id);

  @POST('/post')
  Future<String> postFormData(@Part() Task task, {@Part() required File file});

  @POST('/post')
  Future<String> postFormData2(
    @Part() List<Map<String, dynamic>> task,
    @Part() List<String> tags,
    @Part(contentType: 'application/json') File file,
  );

  @POST('/post')
  Future<String> postFormData3({
    @Part(name: 'customfiles', contentType: 'application/json')
    required List<File> files,
    @Part() required File file,
  });

  @POST('/post')
  Future<String> postFormData6({
    @Part(name: 'customfiles') required List<List<int>> files,
    @Part() required List<int> file,
  });

  @POST('/post')
  Future<String> postFormData4(@Part() List<Task> tasks, @Part() File file);

  @POST('/post')
  Future<String> postFormData5(
    @Part() List<Task> tasks,
    @Part() Map<String, dynamic> map,
    @Part() int a, {
    @Part() required bool b,
    @Part() required double c,
    @Part() required String d,
  });

  @GET('/demo')
  Future<String> queries(@Queries() Map<String, dynamic> queries);

  @GET('/enums')
  Future<String> queryByEnum(@Query('tasks') TaskQuery query);

  @GET('/get')
  Future<String> namedExample(
    @Query(r'$apikey') String apiKey,
    @Query('scope') String scope,
    @Query('type') String type, {
    @Query('from') int? from,
  });

  @POST('/postfile')
  @Headers(<String, dynamic>{
    r'$Content-Type': 'application/octet-stream',
    'Ocp-Apim-Subscription-Key': 'abc',
  })
  Future<String> postFile({@Body() required File file});

  @GET('')
  Future<String> testCustomOptions(@DioOptions() Options options);
}

@JsonSerializable()
class Task {
  const Task({
    this.id,
    this.name,
    this.avatar,
    this.createdAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  final String? id;
  final String? name;
  final String? avatar;
  final String? createdAt;

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
    this.date,
    this.todos,
    this.completed,
    this.inProgress,
  });

  factory TaskGroup.fromJson(Map<String, dynamic> json) =>
      _$TaskGroupFromJson(json);

  final DateTime? date;
  final List<Task>? todos;
  final List<Task>? completed;
  final List<Task>? inProgress;

  Map<String, dynamic> toJson() => _$TaskGroupToJson(this);
}
