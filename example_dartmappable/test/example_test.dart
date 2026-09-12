import 'package:dio/dio.dart';
import 'package:retrofit_example_dartmappable/example.dart';
import 'package:test/test.dart';

void main() {
  test(
      'ApiService deserializes Task using dart_mappable configured in build.yaml',
      () async {
    final dio = Dio();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (options.path.endsWith('/tasks')) {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: [
                  {'id': '1', 'name': 'Task 1', 'avatar': 'avatar.png'},
                ],
              ),
            );
            return;
          }
          handler.next(options);
        },
      ),
    );

    final api = ApiService(dio, baseUrl: 'https://example.com/api/');
    final tasks = await api.getTasks();
    expect(tasks, hasLength(1));
    expect(tasks.first.id, equals('1'));
    expect(tasks.first.name, equals('Task 1'));
  });
}
