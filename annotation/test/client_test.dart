import 'dart:convert';
import 'package:retrofit/retrofit.dart';
import 'package:test/test.dart';
import 'package:mock_web_server/mock_web_server.dart';

MockWebServer _server;
const jsonContentHeader = {'Content-Type': 'application/json'};

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

    final res = await client.request(Request(HttpMethod.GET, '/'));
    expect(res.status, 404);
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
        .enqueue(body: content, headers:jsonContentHeader );
    final value = await client.request(Request(HttpMethod.GET, '/'));

    expect(value.body.toString(), content);
  });

  test('client request json object', () async {
    final client = Client(baseUrl: _server.url);
    final content = {'name': 'trevor', 'age': 33};
    _server.enqueue(
        body: json.encode(content),
        headers:jsonContentHeader);
    final value = await client.request(Request(HttpMethod.GET, '/'));

    expect(value.body, content);
    expect(value.body['name'], 'trevor');
  });

  test('client request json array', () async {
    final client = Client(baseUrl: _server.url);
    final content = ['1', '2', '3'];
    _server.enqueue(
        body: json.encode(content),
        headers: jsonContentHeader);
    final value = await client.request(Request(HttpMethod.GET, '/'));
    expect(value.body, content);
    expect(value.body is List, isTrue);
    expect((value.body as List).length, 3);
  });
}
