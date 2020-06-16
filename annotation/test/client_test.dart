import 'dart:convert';
import 'package:retrofit/retrofit.dart';
import 'package:test/test.dart';
import 'package:mock_web_server/mock_web_server.dart';

MockWebServer _server;
const jsonContentHeader = {'Content-Type': 'application/json'};
Client client;

void main() {
  setUp(() async {
    _server = MockWebServer();
    await _server.start();
    client = Client(baseUrl: _server.url);
  });

  tearDown(() async {
    await _server.shutdown();
    _server = null;
  });

  group('basic http >> ', () {
    test('http ok', () async {
      _server.enqueue(httpCode: 200);
      final res = await client.request(Request(HttpMethod.GET, '/'));
      expect(res.status, 200);
    });

    test('http not found', () async {
      _server.enqueue(httpCode: 404);
      final res = await client.request(Request(HttpMethod.GET, '/'));
      expect(res.status, 404);
    });

    test('client request plain text', () async {
      _server.enqueue(body: '');
      final value = await client.request(Request(HttpMethod.GET, '/'));
      expect(value.body, '');
    });

    test('client request json content', () async {
      final content = '{}';
      _server.enqueue(body: content, headers: jsonContentHeader);
      final value = await client.request(Request(HttpMethod.GET, '/'));

      expect(value.body.toString(), content);
    });

    test('client request json object', () async {
      final content = {'name': 'trevor', 'age': 33};
      _server.enqueue(body: json.encode(content), headers: jsonContentHeader);
      final value = await client.request(Request(HttpMethod.GET, '/'));

      expect(value.body, content);
      expect(value.body['name'], 'trevor');
    });

    test('client request json array', () async {
      final content = ['1', '2', '3'];
      _server.enqueue(body: json.encode(content), headers: jsonContentHeader);
      final value = await client.request(Request(HttpMethod.GET, '/'));
      expect(value.body, content);
      expect(value.body is List, isTrue);
      expect((value.body as List).length, 3);
    });

    test('http method', () async {
      final methods = [
        HttpMethod.GET,
        HttpMethod.HEAD,
        HttpMethod.POST,
        HttpMethod.PUT,
        HttpMethod.DELETE,
        HttpMethod.OPTIONS,
        HttpMethod.PATCH,
      ];

      for (var method in methods) {
        _server.enqueue(body: method);
        final res = await client.request(Request(method, '/'));
        expect(res.response.request.method, method);
        if (method != HttpMethod.HEAD) expect(res.body, method);
      }
    });
  });
}
