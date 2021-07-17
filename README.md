# Retrofit For Dart

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
  retrofit: any
  logger: any  #for logging purpose

dev_dependencies:
  retrofit_generator: any
  build_runner: any
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
  final dio = Dio();   // Provide a dio instance
  dio.options.headers["Demo-Header"] = "demo header";   // config your dio headers globally
  final client = RestClient(dio);
  
  client.getTasks().then((it) => logger.i(it));
```



## More

### Type Conversion

> Before you use the type conversion, please make sure that a ` factory Task.fromJson(Map<String, dynamic> json)` must be provided for each model class. `json_serializable` is the recommanded to be used as the serialization tool.

```dart
...
@GET("/tasks")
  Future<List<Task>> getTasks();
}

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
  Future<HttpResponse<Task>> getTask(@Path("id") String id)

  @GET("/tasks")
  Future<HttpResponse<List<Task>>>> getTasks()
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
 client.getTask("2").then((it){
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
    }
  });

}
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

### Hide generated files

For the project not to be confused with the files generated by the retrofit you can hide them.

##### Android studio 

`File -> Settings -> Editor -> File Types`

Add "ignore files and folders"

`*.g.dart`
 
 



