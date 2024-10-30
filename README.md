# Retrofit For Dart

[![retrofit](https://img.shields.io/pub/v/retrofit?label=retrofit&style=flat-square)](https://pub.dartlang.org/packages/retrofit)
[![retrofit_generator](https://img.shields.io/pub/v/retrofit_generator?label=retrofit_generator&style=flat-square)](https://pub.dartlang.org/packages/retrofit_generator)
![Pub Likes](https://img.shields.io/pub/likes/retrofit)
[![Testing](https://github.com/trevorwang/retrofit.dart/actions/workflows/test.yml/badge.svg)](https://github.com/trevorwang/retrofit.dart/actions/workflows/test.yml)

retrofit.dart is a type conversion [dio](https://github.com/flutterchina/dio/) client generator using [source_gen](https://github.com/dart-lang/source_gen) and inspired by [Chopper](https://github.com/lejard-h/chopper) and [Retrofit](https://github.com/square/retrofit).

## Usage

### Generator

Add the generator to your dev dependencies

```yaml
dependencies:
  retrofit: ^4.4.0
  logger: ^2.4.0  # for logging purpose
  json_annotation: ^4.9.0

dev_dependencies:
  retrofit_generator: '>=8.0.0 <10.0.0' # for Dart 3.3 use ^9.0.0
  build_runner: ^2.3.3
  json_serializable: ^6.8.0
```

### Define and Generate your API

```dart
import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

part 'example.g.dart';

@RestApi(baseUrl: 'https://5d42a6e2bc64f90014a56ca0.mockapi.io/api/v1/')
abstract class RestClient {
  factory RestClient(Dio dio, {String? baseUrl}) = _RestClient;

  @GET('/tasks')
  Future<List<Task>> getTasks();
}

@JsonSerializable()
class Task {
  const Task({this.id, this.name, this.avatar, this.createdAt});

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  final String? id;
  final String? name;
  final String? avatar;
  final String? createdAt;

  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
```

then run the generator

```sh
# dart
dart pub run build_runner build
```

### Use it

```dart
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:retrofit_example/example.dart';

final logger = Logger();

void main(List<String> args) {
  final dio = Dio(); // Provide a dio instance
  dio.options.headers['Demo-Header'] = 'demo header'; // config your dio headers globally
  final client = RestClient(dio);

  client.getTasks().then((it) => logger.i(it));
}
```

## More

### Types

#### Types conversion

> Before you use the type conversion, please make sure that a ` factory Task.fromJson(Map<String, dynamic> json)` must be provided for each model class. `json_serializable` is recommended to be used as the serialization tool.

```dart
@GET('/tasks')
Future<List<Task>> getTasks();

@JsonSerializable()
class Task {
  const Task({required this.name});

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  final String name;
}
```

#### Typed extras
If you want to add static extra to all requests.

```dart
class MetaData extends TypedExtras {
  final String id;
  final String region;

  const MetaData({required this.id, required region});
}

@MetaData(
  id: '1234',
  region: 'ng',
)
@GET("/get")
Future<String> fetchData();

```

### HTTP Methods

The HTTP methods in the below sample are supported.

```dart
  @GET('/tasks/{id}')
  Future<Task> getTask(@Path('id') String id);
  
  @GET('/demo')
  Future<String> queries(@Queries() Map<String, dynamic> queries);
  
  @GET('https://httpbin.org/get')
  Future<String> namedExample(
      @Query('apikey') String apiKey,
      @Query('scope') String scope,
      @Query('type') String type,
      @Query('from') int from,
  );
  
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
  
  @POST('http://httpbin.org/post')
  @FormUrlEncoded()
  Future<String> postUrlEncodedFormData(@Field() String hello);
```

### Get original HTTP response

```dart
  @GET('/tasks/{id}')
  Future<HttpResponse<Task>> getTask(@Path('id') String id);

  @GET('/tasks')
  Future<HttpResponse<List<Task>>> getTasks();
```
### HTTP Header

* Add a HTTP header from the parameter of the method

```dart
  @GET('/tasks')
  Future<Task> getTasks(@Header('Content-Type') String contentType);
 ```

* Add static HTTP headers

```dart
  import 'package:dio/dio.dart' hide Headers;

  // ...
  
  @GET('/tasks')
  @Headers(<String, dynamic>{
    'Content-Type': 'application/json',
    'Custom-Header': 'Your header',
  })
  Future<Task> getTasks();
```



### Error Handling

`catchError(Object)` should be used for capturing the exception and failed response. You can get the detailed response info from `DioError.response`.

```dart
client.getTask('2').then((it) {
  logger.i(it);
}).catchError((obj) {
  // non-200 error goes here.
  switch (obj.runtimeType) {
    case DioException:
      // Here's the sample to get the failed response error code and message
      final res = (obj as DioException).response;
      logger.e('Got error : ${res.statusCode} -> ${res.statusMessage}');
      break;
  default:
    break;
  }
});
```

### Relative API baseUrl

If you want to use a relative `baseUrl` value in the `RestApi` annotation of the `RestClient`, you need to specify a `baseUrl` in `dio.options.baseUrl`.

```dart
@RestApi(baseUrl: '/tasks')
abstract class RestClient {
  factory RestClient(Dio dio, {String? baseUrl}) = _RestClient;

  @GET('{id}')
  Future<HttpResponse<Task>> getTask(@Path('id') String id);

  @GET('')
  Future<HttpResponse<List<Task>>> getTasks();
}

dio.options.baseUrl = 'https://5d42a6e2bc64f90014a56ca0.mockapi.io/api/v1';
final client = RestClient(dio);
```

### Multiple endpoints support

If you want to use multiple endpoints to your `RestClient`, you should pass your base url when you initiate `RestClient`. Any value defined in `RestApi` will be ignored.

```dart
@RestApi(baseUrl: 'this url will be ignored if baseUrl is passed')
abstract class RestClient {
  factory RestClient(Dio dio, {String? baseUrl}) = _RestClient;
}

final client = RestClient(dio, baseUrl: 'your base url');
```

If you want to use the base url from `dio.option.baseUrl`, which has lowest priority, please don't pass any parameter to `RestApi` annotation and `RestClient`'s structure method.

### Multithreading (Flutter only)

If you want to parse models on a separate thread, you can take advantage of the `compute` function, just like Dio does when converting String data responses into json objects.

For each model that you use you will need to define 2 top-level functions:
```dart
FutureOr<Task> deserializeTask(Map<String, dynamic> json);
FutureOr<dynamic> serializeTask(Task object);
```

If you want to handle lists of objects, either as return types or parameters, you should provide List counterparts:

```dart
FutureOr<List<Task>> deserializeTaskList(Map<String, dynamic> json);
FutureOr<dynamic> serializeTaskList(List<Task> objects);
```

Finally, make sure you set your `@RestApi` to use the `Parser.FlutterCompute` parser:

```dart
@RestApi(parser: Parser.FlutterCompute)
```

E.g.
```dart
@RestApi(
  baseUrl: 'https://5d42a6e2bc64f90014a56ca0.mockapi.io/api/v1/',
  parser: Parser.FlutterCompute,
)
abstract class RestClient {
  factory RestClient(Dio dio, {String? baseUrl}) = _RestClient;

  @GET('/task')
  Future<Task> getTask();

  @GET('/tasks')
  Future<List<Task>> getTasks();

  @POST('/task')
  Future<void> updateTasks(Task task);

  @POST('/tasks')
  Future<void> updateTasks(List<Task> tasks);
}

Task deserializeTask(Map<String, dynamic> json) => Task.fromJson(json);

List<Task> deserializeTaskList(List<Map<String, dynamic>> json) =>
    json.map((e) => Task.fromJson(e)).toList();

Map<String, dynamic> serializeTask(Task object) => object.toJson();

List<Map<String, dynamic>> serializeTaskList(List<Task> objects) =>
    objects.map((e) => e.toJson()).toList();
```

N.B.
Avoid using Map values, otherwise multiple background isolates will be spawned to perform the computation, which is extremely intensive for Dart.

```dart
abstract class RestClient {
  factory RestClient(Dio dio, {String? baseUrl}) = _RestClient;

  // BAD
  @GET('/tasks')
  Future<Map<String, Task>> getTasks();

  @POST('/tasks')
  Future<void> updateTasks(Map<String, Task> tasks);

  // GOOD
  @GET('/tasks_names')
  Future<TaskNames> getTaskNames();

  @POST('/tasks_names')
  Future<void> updateTasks(TaskNames tasks);
}

TaskNames deserializeTaskNames(Map<String, dynamic> json) =>
    TaskNames.fromJson(json);

@JsonSerializable
class TaskNames {
  const TaskNames({required this.taskNames});

  final Map<String, Task> taskNames;

  factory TaskNames.fromJson(Map<String, dynamic> json) =>
      _$TaskNamesFromJson(json);
}
```

### Hide generated files

For the project not to be confused with the files generated by the retrofit you can hide them.

##### Android studio

`File -> Settings -> Editor -> File Types`

Add "ignore files and folders"

`*.g.dart`

## Videos
- [Flutter Rest API - Simplifying Make API Call Using Retrofit](https://www.youtube.com/watch?v=zjNhlmue5Os)
- [Flutter retrofit implementation | Flutter Network Calls | Source Code In Desc | flutter coding](https://www.youtube.com/watch?v=OZF9mqKbi3k)
- [Flutter retrofit api call | GET | amplifyabhi ](https://www.youtube.com/watch?v=ARIy5OSIspQ)
- [Flutter - Retrofit Setup & Explanation | Clean Architecture | In Hindi](https://www.youtube.com/watch?v=e6JV-t9Yo3U)
- [How to call API using retrofit in flutter application and JSON parsing ?](https://www.youtube.com/watch?v=UDhRvP1Iafc)
- [API Integration in Flutter using Retrofit | Flutter Package Tutorial](https://www.youtube.com/watch?v=upX9T_ciWz4&t=39s)
- [Build A News App - Make Request To API Using Retrofit | PART 4 - Flutter Clean Architecture](https://www.youtube.com/watch?v=kjMoW4cs2kU)


## Credits

- [JetBrains](https://www.jetbrains.com/). Thanks for providing the great IDE tools.


## Contributors ✨

Thanks goes to these wonderful people:

<a href="https://github.com/trevorwang/retrofit.dart/graphs/contributors"><img src="https://opencollective.com/retrofitdart/contributors.svg?width=890&button=false" /></a>

Contributions of any kind welcome!
## Activities

![Alt](https://repobeats.axiom.co/api/embed/76948dfe0698cce4724567ccbf38139823939350.svg "Repobeats analytics image")
