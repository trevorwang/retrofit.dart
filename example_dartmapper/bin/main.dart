import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:retrofit_example/example.dart';
import 'package:retrofit_example/json_mapper_example.dart' hide Task;
import 'package:retrofit_example/json_mapper_example.reflectable.dart'
    show initializeReflectable;

final logger = Logger();

Future<void> main(List<String> args) async {
  final dio = Dio();
  dio.options.headers['Demo-Header'] = 'demo header';
  dio.options.headers['Content-Type'] = 'application/json';
  final client = RestClient(dio);

  client.getTasks().then((it) => logger.i(it));

  client.getTask('2').then((it) => logger.i(it)).catchError((Object obj) {
    // non-200 error goes here.
    switch (obj.runtimeType) {
      case DioException _:
        final res = (obj as DioException).response;
        logger.e('Got error : ${res?.statusCode} -> ${res?.statusMessage}');
      default:
    }
  });

  client.createTask(Task(avatar: '2222.png', name: 'new task')).then((it) {
    logger.i(it.toJson());
  });

  client
      .updateTask('3', Task(id: '4', avatar: '1.png', name: 'number 3'))
      .then((it) {
    logger.i(it.toJson());
  });

  client
      .updateTaskPart(
          '4', Task(id: '4', avatar: '1.png', name: 'number 4').toJson())
      .then((it) {
    logger.i(it.toJson());
  });

  client.deleteTask('2').then((it) {
    logger.i('taks 2 has been deleted!');
  }).catchError((Object err) {
    logger.e(err);
  });

  client.createNewTaskFromFile(File('main.dart')).catchError((Object err) {
    print(err);
  });
  client.getFile().then((it) {
    print(it.length);
  });

  initializeReflectable();
  final api = ApiService(dio);
  api.getTasks(DateTime.now()).then((it) => logger.i(it.toString()));
}
