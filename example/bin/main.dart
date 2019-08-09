import 'package:logger/logger.dart';
import 'package:retrofit_example/example.dart';
import 'package:dio/dio.dart';

final logger = Logger();
void main(List<String> args) {
  final dio = Dio();
  dio.options.headers["Demo-Header"] = "demo header";
  dio.options.headers["Content-Type"] = "application/json";
  final client = RestClient(dio);

  client.getTasks().then((it) => print(it));

  client.getTask("3").then((it) => print(it)).catchError((Object obj) {
    switch (obj.runtimeType) {
      case DioError:
        logger.e((obj as DioError).message);
        break;
      default:
    }
  });

  client.createTask(Task(avatar: "2222.png", name: "new task")).then((it) {
    logger.i(it.toJson());
  });

  client
      .updateTask("3", Task(id: "4", avatar: "1.png", name: "number 3"))
      .then((it) {
    logger.i(it.toJson());
  });

  client
      .updateTaskPart(
          "4", Task(id: "4", avatar: "1.png", name: "number 4").toJson())
      .then((it) {
    logger.i(it.toJson());
  });

  client.deleteTask("2").then((it) {
    logger.i("taks 2 has been deleted!");
  }).catchError((Object err) {
    logger.e(err);
  });
}
