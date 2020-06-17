import 'dart:convert';

import 'package:retrofit/retrofit.dart';
import 'package:retrofit/src/utils.dart';
import 'package:test/test.dart';
import 'package:mock_web_server/mock_web_server.dart';
import 'dart:io';

MockWebServer _server;
Client client;

void main() {
  setUp(() async {
    _server = MockWebServer();
    _server.dispatcher = (request) async {
      return MockResponse()
        ..body = ''
        ..httpCode = 200;
    };
    await _server.start();
    client = Client(baseUrl: _server.url);
  });

  tearDown(() async {
    await _server.shutdown();
    _server = null;
  });
  test('text', () async {
    final partList = [
      PartValue<String>('name', 'peter'),
      PartValue<int>('age', 13),
    ];

    final request =
        Request(HttpMethod.POST, '/', parts: partList, multipart: true);
    await client.request(request);
    final req = _server.takeRequest();
    expect(req.headers[contentTypeKey], contains('multipart/form-data'));
    expect(
        req.body,
        contains(
          'content-disposition: form-data; name="name"\r\n'
          '\r\n'
          'peter\r\n',
        ));
    expect(
        req.body,
        contains(
          'content-disposition: form-data; name="age"\r\n'
          '\r\n13'
          '\r\n',
        ));
  });

  test('file', () async {
    final partList = [
      PartValue<String>('name', 'peter'),
      PartValue<File>('file', File('./README.md'))
    ];

    final request =
        Request(HttpMethod.POST, '/', parts: partList, multipart: true);
    await client.request(request);
    final req = _server.takeRequest();
    expect(req.headers[contentTypeKey],
        contains('multipart/form-data; boundary='));
    expect(
        req.body,
        contains(
          'content-disposition: form-data; name="name"\r\n'
          '\r\n'
          'peter\r\n',
        ));
    expect(
        req.body,
        contains(
          'content-disposition: form-data; name="file"; filename="README.md"\r\n'
          'content-type: application/octet-stream\r\n'
          '\r\n'
          '# Retrofit For Dart\n',
        ));
  });

  test('bytes', () async {
    final content = 'hello world!';
    final partList = [PartValue<List<int>>('bytes', content.codeUnits)];

    final request =
        Request(HttpMethod.POST, '/', parts: partList, multipart: true);
    await client.request(request);
    final req = _server.takeRequest();
    expect(req.headers[contentTypeKey],
        contains('multipart/form-data; boundary='));
    expect(
        req.body,
        contains(
          'content-disposition: form-data; name="bytes"\r\n'
          'content-type: application/octet-stream\r\n'
          '\r\n'
          '${content}\r\n',
        ));
  });

  test('file content type', () async {
    final content = json.encode({'name': 'peter', 'age': 13});
    final partList = [
      PartFile<List<int>>('bytes', content.codeUnits, contentType: jsonType)
    ];

    final request =
        Request(HttpMethod.POST, '/', parts: partList, multipart: true);
    await client.request(request);
    final req = _server.takeRequest();
    expect(req.headers[contentTypeKey],
        contains('multipart/form-data; boundary='));
    expect(
        req.body,
        contains(
          'content-disposition: form-data; name="bytes"\r\n'
          'content-type: ${jsonType}\r\n'
          '\r\n'
          '${content}\r\n',
        ));
  });
}
