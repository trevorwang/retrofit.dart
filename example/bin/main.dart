import 'package:retrofit_example/demo.dart';

main(List<String> args) {
  final client = RestClient.instance;

  client.ip("trevor").then((it) => print(it));
}
