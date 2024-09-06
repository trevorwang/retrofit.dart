import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mock_web_server/mock_web_server.dart';
import 'package:retrofit_example/example.dart';
import 'package:retrofit_example/json_mapper_example.dart';
import 'package:retrofit_example/json_mapper_example.reflectable.dart'
    show initializeReflectable;
import 'package:test/test.dart';

import 'task_data.dart';

late MockWebServer _server;
late RestClient _client;
late ApiService _apiService;
final _headers = {"Content-Type": "application/json"};
final dispatcherMap = <String, MockResponse>{};

void main() {
  setUp(() async {
    _server = MockWebServer();
    // _server.dispatcher = (HttpRequest request) async {
    //   var res = dispatcherMap[request.uri.path];
    //   if (res != null) {
    //     return res;
    //   }
    //   return new MockResponse()..httpCode = 404;
    // };
    await _server.start();
    final dio = Dio();
    dio.interceptors.add(LogInterceptor(responseBody: true));
    dio.interceptors.add(DateTimeInterceptor());
    _client = RestClient(dio, baseUrl: _server.url);

    initializeReflectable();
    _apiService = ApiService(dio, baseUrl: _server.url);
  });

  tearDown(() {
    _server.shutdown();
  });

  test("test tag list", () async {
    print(jsonEncode(["tag1", "tag2"]));
    _server.enqueue(
        body: jsonEncode(["tag1", "tag2"]),
        headers: {"Content-Type": "application/json"});
    final tasks = await _client.getTags();
    expect(tasks, isNotNull);
    expect(tasks.length, 2);
  });

  test("test stream tag list", () async {
    print(jsonEncode(["tag1", "tag2"]));
    _server.enqueue(
        body: jsonEncode(["tag1", "tag2"]),
        headers: {"Content-Type": "application/json"});
    final tasksStream = _client.getTagsAsStream();
    final tasks = await tasksStream.first;
    expect(tasks, isNotNull);
    expect(tasks.length, 2);
  });

  test("test empy task list", () async {
    _server.enqueue(
        body: demoEmptyListJson, headers: {"Content-Type": "application/json"});
    final tasks = await _client.getTasks();
    expect(tasks, isNotNull);
    expect(tasks.length, 0);
  });

  test("test task list", () async {
    _server.enqueue(body: demoTaskListJson, headers: _headers);
    final tasks = await _client.getTasks();
    expect(tasks, isNotNull);
    expect(tasks.length, 1);
  });

  test("test task detail", () async {
    _server.enqueue(headers: _headers, body: demoTaskJson);
    final task = await _client.getTask("id");
    expect(task, isNotNull);
    expect(task.id, demoTask.id);
    expect(task.avatar, demoTask.avatar);
    expect(task.name, demoTask.name);
    expect(task.createdAt, demoTask.createdAt);
  });

  test("create new task", () async {
    _server.enqueue(headers: _headers, body: demoTaskJson);
    final task = await _client.createTask(demoTask);
    expect(task, isNotNull);
    expect(task.id, demoTask.id);
    expect(task.avatar, demoTask.avatar);
    expect(task.name, demoTask.name);
    expect(task.createdAt, demoTask.createdAt);
  });

  test("update task all content", () async {
    _server.enqueue(headers: _headers, body: demoTaskJson);
    final task = await _client.updateTask("id", demoTask);
    expect(task, isNotNull);
    expect(task.id, demoTask.id);
    expect(task.avatar, demoTask.avatar);
    expect(task.name, demoTask.name);
    expect(task.createdAt, demoTask.createdAt);
  });

  test("update task part content", () async {
    _server.enqueue(headers: _headers, body: demoTaskJson);
    final task = await _client.updateTaskPart("id", {"name": "demo name 2"});
    expect(task, isNotNull);
    expect(task.id, demoTask.id);
    expect(task.avatar, demoTask.avatar);
    expect(task.name, demoTask.name);
    expect(task.createdAt, demoTask.createdAt);
  });

  test("delete a task", () async {
    _server.enqueue();
    await _client.deleteTask("id").then((it) {
      expect(null, null);
    });
  });

  test("Test group list task", () async {
    _server.enqueue(headers: _headers, body: groupTaskListJson);
    final result = await _client.grouppedTaskByDate();
    expect(result, isNotNull);
    expect(result.first.todos, isNotEmpty);
    expect(result.first.todos?.first.avatar, demoTask.avatar);
  });

  test("test json mapper parse task", () async {
    _server.enqueue(body: demoTaskListJson, headers: _headers);
    final tasks = await _apiService.getTasks(DateTime.now());
    expect(tasks, isNotNull);
    expect(tasks.length, 1);
  });

  test('test escaping character in query & headers', () async {
    _server.enqueue(body: 'hello');
    await _client.namedExample("apkKeyvalue", "hello", "ggggg");
    expect(true, true);
  });
}

class DateTimeInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
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
