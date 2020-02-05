import 'dart:convert';

import 'package:test/test.dart';
import 'package:dio/dio.dart';
import 'package:mock_web_server/mock_web_server.dart';
import '../example/lib/demo.dart';

MockWebServer _server;
DemoClient _client;
final keyContentType = 'Content-Type';
final _headers = {keyContentType: "application/json"};
void main() {
  setUp(() async {
    _server = MockWebServer();
    await _server.start();
    var dio = Dio();
    dio.options.baseUrl = _server.url;
    _client = DemoClient(dio);
  });

  tearDown(() {
    _server.shutdown();
  });

  test("nested with list", () async {
    _server.enqueue(body: jsonEncode(data), headers: _headers);
    final tasks = await _client.getData();
    expect(tasks, isNotNull);
    print(tasks.toJson());
  });

  test("original response data", () async {
    _server.enqueue(body: jsonEncode(data), headers: _headers);
    final res = await _client.getData2();
    expect(res, isNotNull);
    expect(res.data.page, data["page"]);
    expect(res.response.headers[keyContentType].join(';'),
        _headers[keyContentType]);
  });
}
