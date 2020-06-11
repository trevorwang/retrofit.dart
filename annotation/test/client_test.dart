import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:test/test.dart';
import 'package:mock_web_server/mock_web_server.dart';

MockWebServer _server;

void main() {
  setUp(() async {
    _server = MockWebServer();
    _server.start();
  });

  test('http ok', () async {
    final client = Client(baseUrl: _server.url);
    _server.enqueue(httpCode: 200);
    final res = await client.request(Request(HttpMethod.GET, '/'));
    expect(res.status, 200);
  });

  test('http not found', () async {
    final client = Client(baseUrl: _server.url);
    _server.enqueue(httpCode: 404);
    try {
      await client.request(Request(HttpMethod.GET, '/'));
    } on DioError catch (e) {
      expect(e.response.statusCode, 404);
    }
  });

  test('client request plain text', () async {
    final client = Client(baseUrl: _server.url);
    _server.enqueue(body: '');
    final value = await client.request(Request(HttpMethod.GET, '/'));

    expect(value.body, '');
  });

  test('client request json content', () async {
    final client = Client(baseUrl: _server.url);
    final content = '{}';
    _server
        .enqueue(body: content, headers: {'content-type': 'application/json'});
    final value = await client.request(Request(HttpMethod.GET, '/'));

    expect(value.body, content);
  });

  test('client request json object', () async {
    final client = Client(baseUrl: _server.url);
    final content = {'name': 'trevor', 'age': 33};
    _server.enqueue(
        body: json.encode(content),
        headers: {'content-type': 'application/json'});
    final value = await client.request(Request(HttpMethod.GET, '/'));

    expect(value.body, content);
    expect(value.body['name'], 'trevor');
  });

  test('client request json array', () async {
    final client = Client(baseUrl: _server.url);
    final content = ['1', '2', '3'];
    _server.enqueue(
        body: json.encode(content),
        headers: {'content-type': 'application/json'});
    final value = await client.request(Request(HttpMethod.GET, '/'));
    expect(value.body, content);
    expect(value.body is List, isTrue);
    expect((value.body as List).length, 3);
  });
}
