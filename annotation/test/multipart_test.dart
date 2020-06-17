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
  test('multipart string', () async {
    final partList = [
      PartValue<String>('name', 'peter'),
      PartValue<int>('age', 13),
    ];

    final request =
        Request(HttpMethod.POST, '/', parts: partList, multipart: true);
    await client.request(request);
    final req = _server.takeRequest();
    expect(
        req.body,
        contains(
            'content-disposition: form-data; name="name"\r\n\r\npeter\r\n'));
    expect(req.body,
        contains('content-disposition: form-data; name="age"\r\n\r\n13\r\n'));
    expect(req.headers[contentTypeKey], contains('multipart/form-data'));
  });
}
