import 'package:retrofit_example/demo.dart';
import 'package:dio/dio.dart';

main(List<String> args) {
  final dio = Dio();
  dio.options.headers["Demo-Header"] = "demo header";
  final client = RestClient.instance(dio);

  client.ip("trevor").then((it) => print(it));
}
