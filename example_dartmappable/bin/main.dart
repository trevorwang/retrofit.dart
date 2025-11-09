import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:retrofit_example_dartmappable/example.dart';

final logger = Logger();

Future<void> main(List<String> args) async {
  final dio = Dio();
  dio.options.headers['Demo-Header'] = 'demo header';
  dio.options.headers['Content-Type'] = 'application/json';
  final client = ApiService(dio);

  // Get all tasks
  client.getTasks().then((it) => logger.i(it));

  // Get a single task
  client.getTask('2').then((it) => logger.i(it)).catchError((Object obj) {
    switch (obj.runtimeType) {
      case DioException _:
        final res = (obj as DioException).response;
        logger.e('Got error : ${res?.statusCode} -> ${res?.statusMessage}');
      default:
    }
  });

  // Create a new task
  client.createTask(const Task(avatar: '2222.png', name: 'new task')).then((it) {
    logger.i(it.toMap());
  });

  // Update a task
  client
      .updateTask('3', const Task(id: '4', avatar: '1.png', name: 'number 3'))
      .then((it) {
    logger.i(it.toMap());
  });

  // Delete a task
  client.deleteTask('2').then((it) {
    logger.i('Task 2 has been deleted!');
  }).catchError((Object err) {
    logger.e(err);
  });
}
