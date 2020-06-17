import 'package:retrofit/retrofit.dart';
import 'package:retrofit/src/utils.dart';
import 'package:test/test.dart';
import 'package:mock_web_server/mock_web_server.dart';

MockWebServer _server;
const formUrlEncodedHeader = {contentTypeKey: formUrlEncodedType};
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
  test('form url encoded body', () async {
    final body = {'hello': 'world', 'age': 24};
    final req = Request(HttpMethod.POST, '/',
        body: body, headers: formUrlEncodedHeader);
    await client.request(req);
    final request = _server.takeRequest();

    expect(request.headers[contentTypeKey], formUrlEncodedType);
    expect(request.body, 'hello=world&age=24');
  });
}
