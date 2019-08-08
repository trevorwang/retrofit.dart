import 'package:retrofit_example/example.dart';
import 'package:dio/dio.dart';

void main(List<String> args) {
  final dio = Dio();
  dio.options.headers["Demo-Header"] = "demo header";
  dio.options.headers["Content-Type"] = "application/json";
  final client = RestClient(dio);
  client.ip("trevor").then((it) => print(it.toJson()));
}
