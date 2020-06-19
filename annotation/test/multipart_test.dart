import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:retrofit/src/utils.dart';
import 'package:test/test.dart';
import 'package:mock_web_server/mock_web_server.dart';

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

  test('bytes and bytes list', () async {
    final content = 'hello world!';
    final bytesListContent = 'bytes list';
    final partList = [
      PartValue<List<int>>('bytes', content.codeUnits),
      PartValue<List<List<int>>>('bytes list', [bytesListContent.codeUnits]),
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

  test('MultiPartFile and list', () async {
    final content = json.encode({'name': 'peter', 'age': 13});
    final name = '1';
    final listContentName = '2';
    final listContent = 'Hello  MultipartFile array';
    final partList = [
      PartValue(name, MultipartFile.fromBytes(content.codeUnits)),
      PartValue(listContentName, [
        MultipartFile.fromBytes(listContent.codeUnits),
        MultipartFile.fromBytes(listContent.codeUnits)
      ]),
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
          'content-disposition: form-data; name="$name"\r\n'
          'content-type: application/octet-stream\r\n'
          '\r\n'
          '${content}\r\n',
        ));

    expect(
        req.body,
        contains(
          'content-disposition: form-data; name="$listContentName"\r\n'
          'content-type: application/octet-stream\r\n'
          '\r\n'
          '${listContent}\r\n',
        ));
  });
}
