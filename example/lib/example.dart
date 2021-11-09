import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:http_parser/http_parser.dart' show MediaType;
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

part 'example.g.dart';

@RestApi(baseUrl: "https://5d42a6e2bc64f90014a56ca0.mockapi.io/api/v1/")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("/tags")
  Future<List<String>> getTags(
      {@Header("optionalHeader") String? optionalHeader});

  @GET("https://httpbin.org/status/204")
  Future<HttpResponse<void>> reponseWith204();

  @GET("/tags")
  Stream<List<String>> getTagsAsStream();

  @GET("/tasks")
  Future<List<Task>> getTasks();

  @GET("/tasks/{id}")
  Future<Task> getTask(@Path("id") String id);

  @PATCH("/tasks/{id}")
  Future<Task> updateTaskPart(
      @Path() String id, @Body() Map<String, dynamic> map);

  @PUT("/tasks/{id}")
  Future<Task> updateTask(@Path() String id, @Body() Task task);

  @DELETE("/tasks/{id}")
  Future<void> deleteTask(@Path() String id);

  @POST("/tasks")
  Future<Task> createTask(@Body() Task task);

  @POST("/tasks")
  Future<List<Task>> createTasks(@Body() List<Task> tasks);

  @POST("/tasks")
  Future<List<String>> createTaskNames(@Body() List<String> tasks);

  @POST("http://httpbin.org/post")
  Future<void> createNewTaskFromFile(@Part() File file);

  @Headers(<String, String>{"accept": "image/jpeg"})
  @GET("http://httpbin.org/image/jpeg")
  @DioResponseType(ResponseType.bytes)
  Future<List<int>> getFile();

  @POST("http://httpbin.org/post")
  @FormUrlEncoded()
  Future<String> postUrlEncodedFormData(
    @Field() String hello, {
    @Field() required String gg,
  });

  @HEAD('/')
  Future<String> headRequest();

  @HEAD('/')
  Future<String?> headRequestNullable();

  @HEAD('/')
  Future<dynamic> headRquest2();

  @HEAD('/')
  Future<HttpResponse> headRquest3();

  @GET("/task/group")
  Future<List<TaskGroup>> grouppedTaskByDate();

  @GET("/task")
  Future<HttpResponse<List<Task>>> getTasksWithReponse();

  @GET("/task")
  Future<HttpResponse<List<Task>?>> getTasksWithReponseNullable();

  @DELETE("/tasks/{id}")
  Future<HttpResponse<void>> deleteTaskWithResponse(@Path() String id);

  @POST("/post")
  Future<String> postFormData(@Part() Task? task, {@Part() required File file});

  @POST("/post")
  Future<String> postFormData2(
      @Part() List<Map<String, dynamic>> task,
      @Part() List<String>? tags,
      @Part(contentType: 'application/json') File file);

  @POST("/post")
  Future<String> postFormData3({
    @Part(value: "customfiles", contentType: 'application/json')
        required List<File> files,
    @Part(fileName: "abc.txt") required File file,
  });

  @POST("/post")
  Future<String> postFormData6(
      {@Part(value: "customfiles") required List<List<int>> files,
      @Part(fileName: "abc.txt") required List<int> file});

  @POST("/post")
  Future<String> postFormData4(@Part() List<Task> tasks, @Part() File file);

  @POST("/post")
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

  @GET("/get")
  Future<String> namedExample(@Query("\$apikey") String apiKey,
      @Query("scope") String scope, @Query("type") String type,
      {@Query("from") int? from});

  @POST("/postfile")
  @Headers(<String, dynamic>{
    "\$Content-Type": "application/octet-stream",
    "Ocp-Apim-Subscription-Key": "abc"
  })
  Future<String> postFile({@Body() required File file});

  @GET("")
  Future<String> testCustomOptions(@DioOptions() Options options);

  @GET('/cancel')
  Future<String> cancelRequest(@CancelRequest() CancelToken cancelToken);

  @PUT('/sendProgress')
  Future<String> sendProgress(@CancelRequest() CancelToken cancelToken,
      {@SendProgress() ProgressCallback? sendProgress});

  @PUT('/receiveProgress')
  Future<String> receiveProgress(
    @CancelRequest() CancelToken cancelToken, {
    @ReceiveProgress() ProgressCallback? receiveProgress,
  });

  @PUT('/boBody')
  @NoBody()
  Future<String> sendWithoutBody();

  @GET('/nestGeneric')
  Future<ValueWrapper<ValueWrapper<String>>> nestGeneric();

  @GET('cache')
  @CacheControl(
      maxAge: 180,
      maxStale: 300,
      minFresh: 60,
      noCache: true,
      noStore: true,
      noTransform: true,
      onlyIfCached: true,
      other: ['public', 'proxy-revalidate'])
  @Headers({'test': 'tes t'})
  Future<String> cache();

  @POST('post')
  Future<String> genericBase(@Body() ValueWrapper<String> request);

  @POST('post')
  Future<String> genericOther(@Body() ValueWrapper<TaskQuery> request);

  @POST('post')
  Future<String> genericMap(@Body() ValueWrapper<Map<String, dynamic>> request);

  @POST('post')
  Future<String> genericListBase(@Body() ValueWrapper<List<String>> request);

  @POST('post')
  Future<String> genericListOther(
      @Body() ValueWrapper<List<TaskQuery>> request);

  @POST('post')
  Future<String> genericListGeneric(
      @Body() ValueWrapper<List<ValueWrapper<TaskQuery>>> request);

  @POST('post')
  Future<String> nestedGenericBase(
      @Body() ValueWrapper<ValueWrapper<String>> request);

  @POST('post')
  Future<String> nestedGenericOther(
      @Body() ValueWrapper<ValueWrapper<TaskQuery>> request);
}

@JsonSerializable()
class Task {
  String id;
  String name;
  String avatar;
  String createdAt;

  Task(
      {required this.id,
      required this.name,
      required this.avatar,
      required this.createdAt});

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);
}

enum Status {
  @JsonValue("new")
  New,
  @JsonValue("on_going")
  OnGoing,
  @JsonValue("closed")
  Closed,
}

@JsonSerializable()
class TaskQuery {
  List<Status> statuses;

  TaskQuery(this.statuses);

  factory TaskQuery.fromJson(Map<String, dynamic> json) =>
      _$TaskQueryFromJson(json);

  Map<String, dynamic> toJson() => _$TaskQueryToJson(this);
}

@JsonSerializable()
class TaskGroup {
  DateTime date;
  List<Task> todos;
  List<Task> completed;
  List<Task> inProgress;

  TaskGroup(
      {required this.date,
      required this.todos,
      required this.completed,
      required this.inProgress});

  factory TaskGroup.fromJson(Map<String, dynamic> json) =>
      _$TaskGroupFromJson(json);

  Map<String, dynamic> toJson() => _$TaskGroupToJson(this);
}

@JsonSerializable(genericArgumentFactories: true)
class ValueWrapper<T> {
  const ValueWrapper({required this.value});

  final T value;

  factory ValueWrapper.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$ValueWrapperFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ValueWrapperToJson(this, toJsonT);
}
