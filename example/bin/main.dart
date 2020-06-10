import 'package:logger/logger.dart';
import 'package:dio/dio.dart';
import 'package:retrofit_example/example.dart';

final logger = Logger();
void main(List<String> args) {
  final dio = Dio();
  dio.options.headers["Demo-Header"] = "demo header";
  dio.options.headers["Content-Type"] = "application/json";
  final client = RestClient.create(dio);
  client.getTags().then((value) => print(value));
}
