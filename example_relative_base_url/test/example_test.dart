import 'package:dio/dio.dart';
import 'package:mock_web_server/mock_web_server.dart';
import 'package:retrofit_example/example.dart';
import 'package:test/test.dart';

import 'task_data.dart';

late MockWebServer _server;
late TasksRestClient _client;
final _headers = {'Content-Type': 'application/json'};
final dispatcherMap = <String, MockResponse>{};

void main() {
  setUp(() async {
    _server = MockWebServer();
    await _server.start();
    final dio = Dio(BaseOptions(baseUrl: _server.url));
    dio.interceptors.add(LogInterceptor(responseBody: true));
    dio.interceptors.add(DateTimeInterceptor());
    _client = TasksRestClient(dio);
  });

  tearDown(() {
    _server.shutdown();
  });

  test('test empty task list', () async {
    _server.enqueue(
        body: demoEmptyListJson, headers: {'Content-Type': 'application/json'});
    final tasks = await _client.getTasks();
    expect(tasks, isNotNull);
    expect(tasks.length, 0);
  });

  test('test task list', () async {
    _server.enqueue(body: demoTaskListJson, headers: _headers);
    final tasks = await _client.getTasks();
    expect(tasks, isNotNull);
    expect(tasks.length, 1);
  });

  test('test task detail', () async {
    _server.enqueue(headers: _headers, body: demoTaskJson);
    final task = await _client.getTask('id');
    expect(task, isNotNull);
    expect(task.id, demoTask.id);
    expect(task.avatar, demoTask.avatar);
    expect(task.name, demoTask.name);
    expect(task.createdAt, demoTask.createdAt);
  });

  test('create new task', () async {
    _server.enqueue(headers: _headers, body: demoTaskJson);
    final task = await _client.createTask(demoTask);
    expect(task, isNotNull);
    expect(task.id, demoTask.id);
    expect(task.avatar, demoTask.avatar);
    expect(task.name, demoTask.name);
    expect(task.createdAt, demoTask.createdAt);
  });

  test('update task all content', () async {
    _server.enqueue(headers: _headers, body: demoTaskJson);
    final task = await _client.updateTask('id', demoTask);
    expect(task, isNotNull);
    expect(task.id, demoTask.id);
    expect(task.avatar, demoTask.avatar);
    expect(task.name, demoTask.name);
    expect(task.createdAt, demoTask.createdAt);
  });

  test('update task part content', () async {
    _server.enqueue(headers: _headers, body: demoTaskJson);
    final task = await _client
        .updateTaskPart('id', <String, String>{'name': 'demo name 2'});
    expect(task, isNotNull);
    expect(task.id, demoTask.id);
    expect(task.avatar, demoTask.avatar);
    expect(task.name, demoTask.name);
    expect(task.createdAt, demoTask.createdAt);
  });

  test('delete a task', () async {
    _server.enqueue();
    await _client.deleteTask('id').then((it) {
      expect(null, null);
    });
  });
}

class DateTimeInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters = options.queryParameters.map((key, value) {
      if (value is DateTime) {
        //may be change to string from any you use object
        return MapEntry(key, value.toString());
      } else {
        return MapEntry(key, value);
      }
    });
    handler.next(options);
  }
}
