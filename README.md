# Retrofit For Dart

[![CircleCI](https://circleci.com/gh/trevorwang/retrofit.dart.svg?style=svg)](https://circleci.com/gh/trevorwang/retrofit.dart)
[![Build Status](https://travis-ci.org/trevorwang/retrofit.dart.svg?branch=master)](https://travis-ci.org/trevorwang/retrofit.dart)
[![Build Status](https://cloud.drone.io/api/badges/trevorwang/retrofit.dart/status.svg)](https://cloud.drone.io/trevorwang/retrofit.dart)

retrofit.dart is an [dio](https://github.com/flutterchina/dio/) client generator using [source_gen](https://github.com/dart-lang/source_gen) and inspired by [Chopper](https://github.com/lejard-h/chopper) and [Retrofit](https://github.com/square/retrofit).

## Usage

### Generator

Add the generator to your dev dependencies

```yaml
dependencies:
  retrofit: any

dev_dependencies:
  retrofit_generator: any
  build_runner: any
```

### Define and Generate your API

```dart
import 'dart:io';

import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';
import 'package:retrofit_example/http_get.dart';

part 'example.g.dart';

@RestApi(baseUrl: "https://httpbin.org/")
abstract class RestClient {
  factory RestClient(Dio dio) = _RestClient;

  @GET("/get")
  @Headers({
    "Header-One": " header 1",
  })
  Future<HttpGet> ip(@Query('query1') String query,
      {@Queries() Map<String, dynamic> queryies,
      @Header("Header-Two") String header});
}

@JsonSerializable()
class HttpGet {
  final Map<String, String> headers;
  final String origin;
  final String url;

  HttpGet({this.headers, this.origin, this.url});
  // There must be a [fromJson] factory method in model class. 
  factory HttpGet.fromJson(Map<String, dynamic> json) =>
      _$HttpGetFromJson(json);
  Map<String, dynamic> toJson() => _$HttpGetToJson(this);
```

then run the generator

```sh
# dart
pub run build_runner build

# flutter
flutter packages pub run build_runner build
```

### Use it

```dart
main(List<String> args) {
  final dio = Dio();
  dio.options.headers["Demo-Header"] = "demo header";
  dio.options.headers["Content-Type"] = "application/json";
  final client = RestClient(dio);
  client.ip("trevor").then((it) => print(it.toJson()));
}
```

[More details](example/lib/example.dart)
