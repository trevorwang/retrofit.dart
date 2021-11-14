# Retrofit For Dart
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-26-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

[![retrofit](https://img.shields.io/pub/v/retrofit?label=retrofit&style=flat-square)](https://pub.dartlang.org/packages/retrofit)
[![retrofit_generator](https://img.shields.io/pub/v/retrofit_generator?label=retrofit_generator&style=flat-square)](https://pub.dartlang.org/packages/retrofit_generator)
[![Dart CI](https://github.com/trevorwang/retrofit.dart/workflows/Dart%20CI/badge.svg)](https://github.com/trevorwang/retrofit.dart)
[![CircleCI](https://circleci.com/gh/trevorwang/retrofit.dart.svg?style=svg)](https://circleci.com/gh/trevorwang/retrofit.dart)
[![Build Status](https://cloud.drone.io/api/badges/trevorwang/retrofit.dart/status.svg)](https://cloud.drone.io/trevorwang/retrofit.dart)

retrofit.dart is a type conversion [dio](https://github.com/flutterchina/dio/) client generator using [source_gen](https://github.com/dart-lang/source_gen) and inspired by [Chopper](https://github.com/lejard-h/chopper) and [Retrofit](https://github.com/square/retrofit).

## Usage

### Generator

Add the generator to your dev dependencies

```yaml
dependencies:
  retrofit: '>=3.0.0 <4.0.0'
  logger: any  #for logging purpose

dev_dependencies:
  retrofit_generator: '>=3.0.0 <4.0.0'
  build_runner: '>2.3.0 <4.0.0' 
```

### Define and Generate your API

```dart
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'example.g.dart';

@RestApi(baseUrl: "https://5d42a6e2bc64f90014a56ca0.mockapi.io/api/v1/")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("/tasks")
  Future<List<Task>> getTasks();
}

@JsonSerializable()
class Task {
  String id;
  String name;
  String avatar;
  String createdAt;

  Task({this.id, this.name, this.avatar, this.createdAt});

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}

```

then run the generator

```sh
# dart
pub run build_runner build

# flutter	
flutter pub run build_runner build
```

### Use it

```dart
import 'package:logger/logger.dart';
import 'package:retrofit_example/example.dart';
import 'package:dio/dio.dart';

final logger = Logger();
void main(List<String> args) {
  final dio = Dio(); // Provide a dio instance
  dio.options.headers["Demo-Header"] = "demo header"; // config your dio headers globally
  final client = RestClient(dio);

  client.getTasks().then((it) => logger.i(it));
}
```



## More

### Type Conversion

> Before you use the type conversion, please make sure that a ` factory Task.fromJson(Map<String, dynamic> json)` must be provided for each model class. `json_serializable` is the recommanded to be used as the serialization tool.

```dart
@GET("/tasks") Future<List<Task>> getTasks();

@JsonSerializable()
class Task {
  String name;
  Task({this.name});
  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
```



### HTTP Methods

The HTTP methods in the below sample are supported.

```dart
  @GET("/tasks/{id}")
  Future<Task> getTask(@Path("id") String id);

  @GET('/demo')
  Future<String> queries(@Queries() Map<String, dynamic> queries);

  @GET("https://httpbin.org/get")
  Future<String> namedExample(
      @Query("apikey") String apiKey,
      @Query("scope") String scope, 
      @Query("type") String type,
      @Query("from") int from
  );

  @PATCH("/tasks/{id}")
  Future<Task> updateTaskPart(
      @Path() String id, @Body() Map<String, dynamic> map);

  @PUT("/tasks/{id}")
  Future<Task> updateTask(@Path() String id, @Body() Task task);

  @DELETE("/tasks/{id}")
  Future<void> deleteTask(@Path() String id);

  @POST("/tasks")
  Future<Task> createTask(@Body() Task task);

  @POST("http://httpbin.org/post")
  Future<void> createNewTaskFromFile(@Part() File file);

  @POST("http://httpbin.org/post")
  @FormUrlEncoded()
  Future<String> postUrlEncodedFormData(@Field() String hello);
```

### Get original HTTP response

```dart
  @GET("/tasks/{id}")
  Future<HttpResponse<Task>> getTask(@Path("id") String id);

  @GET("/tasks")
  Future<HttpResponse<List<Task>>> getTasks();
```

### HTTP Header

* Add a HTTP header from the parameter of the method

  ```dart
  	@GET("/tasks")
    Future<Task> getTasks(@Header("Content-Type") String contentType );
  ```

  

* Add static HTTP headers

  ```dart
  	@GET("/tasks")
  	@Headers(<String, dynamic>{
  		"Content-Type" : "application/json",
  		"Custom-Header" : "Your header"
  	})
    Future<Task> getTasks();
  ```

  

### Error Handling

`catchError(Object)` should be used for capturing the exception and failed response. You can get the detailed response info from `DioError.response`.

```dart
client.getTask("2").then((it) {
  logger.i(it);
}).catchError((Object obj) {
  // non-200 error goes here.
  switch (obj.runtimeType) {
    case DioError:
      // Here's the sample to get the failed response error code and message
      final res = (obj as DioError).response;
      logger.e("Got error : ${res.statusCode} -> ${res.statusMessage}");
      break;
    default:
      break;
  }
});
```
### Multiple endpoints support

If you want to use multiple endpoints to your `RestClient`, you should pass your base url when you initiate `RestClient`. Any value defined in `RestApi` will be ignored.

```dart
@RestApi(baseUrl: "this url will be ignored if baseUrl is passed")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;
}

final client = RestClient(dio, baseUrl: "your base url");
```

If you want to use the base url from `dio.option.baseUrl`, which has lowest priority, please don't pass any parameter to `RestApi` annotation and `RestClient`'s structure method. 

### Multithreading (Flutter only)

If you want to parse models on a separate thread, you can take advantage of the `compute` function, just like Dio does when converting String data responses into json objects.

For each model that you use you will need to define 2 top-level functions:
```dart
FutureOr<Task> deserializeTask(Map<String, dynamic> json);
FutureOr<dynamic> serializeTask(Task object);
```

If you want to handle lists of objects, either as return types or parameters, you should provide List counterparts.

```dart
FutureOr<List<Task>> deserializeTaskList(Map<String, dynamic> json);
FutureOr<dynamic> serializeTaskList(List<Task> objects);
```

E.g.
```dart
@RestApi(
  baseUrl: "https://5d42a6e2bc64f90014a56ca0.mockapi.io/api/v1/",
  parser: Parser.FlutterCompute,
)
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("/task")
  Future<Task> getTask();
  @GET("/tasks")
  Future<List<Task>> getTasks();

  @POST("/task")
  Future<void> updateTasks(Task task);
  @POST("/tasks")
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
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  // BAD
  @GET("/tasks")
  Future<Map<String, Task>> getTasks();
  @POST("/tasks")
  Future<void> updateTasks(Map<String, Task> tasks);

  // GOOD
  @GET("/tasks_names")
  Future<TaskNames> getTaskNames();
  @POST("/tasks_names")
  Future<void> updateTasks(TaskNames tasks);
}

TaskNames deserializeTaskNames(Map<String, dynamic> json) => TaskNames.fromJson(json);

@JsonSerializable
class TaskNames {
  const TaskNames({required this.tasks});

  final Map<String, Task> taskNames;

  factory TaskNames.fromJson(Map<String, dynamic> json) => _$TaskNamesFromJson(json);
}
```

### Hide generated files

For the project not to be confused with the files generated by the retrofit you can hide them.

##### Android studio 

`File -> Settings -> Editor -> File Types`

Add "ignore files and folders"

`*.g.dart`
 
 ## Credits
 
 - [JetBrains](https://www.jetbrains.com/). Thanks for providing the great IDE tools.


## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="http://mings.in"><img src="https://avatars.githubusercontent.com/u/121966?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Trevor Wang</b></sub></a><br /><a href="#infra-trevorwang" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a> <a href="https://github.com/trevorwang/retrofit.dart/commits?author=trevorwang" title="Tests">⚠️</a> <a href="https://github.com/trevorwang/retrofit.dart/commits?author=trevorwang" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/devkabiir"><img src="https://avatars.githubusercontent.com/u/18462563?v=4?s=100" width="100px;" alt=""/><br /><sub><b>devkabiir</b></sub></a><br /><a href="https://github.com/trevorwang/retrofit.dart/commits?author=devkabiir" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/NicolaVerbeeck"><img src="https://avatars.githubusercontent.com/u/7778415?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Nicola Verbeeck</b></sub></a><br /><a href="https://github.com/trevorwang/retrofit.dart/commits?author=NicolaVerbeeck" title="Code">💻</a></td>
    <td align="center"><a href="https://ipcjs.top/"><img src="https://avatars.githubusercontent.com/u/4396864?v=4?s=100" width="100px;" alt=""/><br /><sub><b>ipcjs</b></sub></a><br /><a href="https://github.com/trevorwang/retrofit.dart/commits?author=ipcjs" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/jiechic"><img src="https://avatars.githubusercontent.com/u/518977?v=4?s=100" width="100px;" alt=""/><br /><sub><b>戒尺</b></sub></a><br /><a href="https://github.com/trevorwang/retrofit.dart/commits?author=jiechic" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/mohn93"><img src="https://avatars.githubusercontent.com/u/11969733?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Mohaned Benmesken</b></sub></a><br /><a href="https://github.com/trevorwang/retrofit.dart/commits?author=mohn93" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/2ZeroSix"><img src="https://avatars.githubusercontent.com/u/14371067?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Bogdan Lukin</b></sub></a><br /><a href="https://github.com/trevorwang/retrofit.dart/commits?author=2ZeroSix" title="Code">💻</a></td>
  </tr>
  <tr>
    <td align="center"><a href="https://sooxt98.space/"><img src="https://avatars.githubusercontent.com/u/13378059?v=4?s=100" width="100px;" alt=""/><br /><sub><b>sooxt98</b></sub></a><br /><a href="https://github.com/trevorwang/retrofit.dart/commits?author=sooxt98" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/SBNTT"><img src="https://avatars.githubusercontent.com/u/20710321?v=4?s=100" width="100px;" alt=""/><br /><sub><b>SBNTT</b></sub></a><br /><a href="https://github.com/trevorwang/retrofit.dart/commits?author=SBNTT" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/Czocher"><img src="https://avatars.githubusercontent.com/u/95644?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Paweł Czochański</b></sub></a><br /><a href="https://github.com/trevorwang/retrofit.dart/commits?author=Czocher" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/bar4488"><img src="https://avatars.githubusercontent.com/u/36762719?v=4?s=100" width="100px;" alt=""/><br /><sub><b>bar4488</b></sub></a><br /><a href="https://github.com/trevorwang/retrofit.dart/commits?author=bar4488" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/via-guy"><img src="https://avatars.githubusercontent.com/u/74960121?v=4?s=100" width="100px;" alt=""/><br /><sub><b>via-guy</b></sub></a><br /><a href="https://github.com/trevorwang/retrofit.dart/commits?author=via-guy" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/martinellimarco"><img src="https://avatars.githubusercontent.com/u/6640057?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Marco Martinelli</b></sub></a><br /><a href="https://github.com/trevorwang/retrofit.dart/commits?author=martinellimarco" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/LeonColt"><img src="https://avatars.githubusercontent.com/u/34907762?v=4?s=100" width="100px;" alt=""/><br /><sub><b>LeonColt</b></sub></a><br /><a href="https://github.com/trevorwang/retrofit.dart/commits?author=LeonColt" title="Code">💻</a></td>
  </tr>
  <tr>
    <td align="center"><a href="https://github.com/alexaf2000"><img src="https://avatars.githubusercontent.com/u/37296203?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Alex A.F.</b></sub></a><br /><a href="https://github.com/trevorwang/retrofit.dart/commits?author=alexaf2000" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/woprandi"><img src="https://avatars.githubusercontent.com/u/1449422?v=4?s=100" width="100px;" alt=""/><br /><sub><b>William Oprandi</b></sub></a><br /><a href="https://github.com/trevorwang/retrofit.dart/commits?author=woprandi" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/Brazol"><img src="https://avatars.githubusercontent.com/u/5622717?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Maciej Brażewicz</b></sub></a><br /><a href="https://github.com/trevorwang/retrofit.dart/commits?author=Brazol" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/lyqiai"><img src="https://avatars.githubusercontent.com/u/22760358?v=4?s=100" width="100px;" alt=""/><br /><sub><b>river</b></sub></a><br /><a href="https://github.com/trevorwang/retrofit.dart/commits?author=lyqiai" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/srburton"><img src="https://avatars.githubusercontent.com/u/15394508?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Renato Burton</b></sub></a><br /><a href="https://github.com/trevorwang/retrofit.dart/commits?author=srburton" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/teddichiiwa"><img src="https://avatars.githubusercontent.com/u/32252270?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Teddy</b></sub></a><br /><a href="https://github.com/trevorwang/retrofit.dart/commits?author=teddichiiwa" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/ignacioberdinas"><img src="https://avatars.githubusercontent.com/u/19497384?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Ignacio Berdiñas</b></sub></a><br /><a href="https://github.com/trevorwang/retrofit.dart/commits?author=ignacioberdinas" title="Code">💻</a></td>
  </tr>
  <tr>
    <td align="center"><a href="https://github.com/themadmrj"><img src="https://avatars.githubusercontent.com/u/11475495?v=4?s=100" width="100px;" alt=""/><br /><sub><b>themadmrj</b></sub></a><br /><a href="https://github.com/trevorwang/retrofit.dart/commits?author=themadmrj" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/stewemetal"><img src="https://avatars.githubusercontent.com/u/5860632?v=4?s=100" width="100px;" alt=""/><br /><sub><b>István Juhos</b></sub></a><br /><a href="https://github.com/trevorwang/retrofit.dart/commits?author=stewemetal" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/Akash98Sky"><img src="https://avatars.githubusercontent.com/u/37451227?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Akash Mondal</b></sub></a><br /><a href="https://github.com/trevorwang/retrofit.dart/commits?author=Akash98Sky" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/JasonHezz"><img src="https://avatars.githubusercontent.com/u/15358765?v=4?s=100" width="100px;" alt=""/><br /><sub><b>JasonHezz</b></sub></a><br /><a href="https://github.com/trevorwang/retrofit.dart/commits?author=JasonHezz" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/gfranks"><img src="https://avatars.githubusercontent.com/u/2064984?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Garrett Franks</b></sub></a><br /><a href="https://github.com/trevorwang/retrofit.dart/commits?author=gfranks" title="Code">💻</a></td>
  </tr>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!
