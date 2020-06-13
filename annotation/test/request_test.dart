import 'package:retrofit/retrofit.dart';
import 'package:test/test.dart';

void main() {
  group('url', () {
    test("url without base url", () async {
      final req = Request(HttpMethod.GET, '/hello');
      expect(req.uri.toString(), '/hello');
    });

    test("url with base url", () async {
      final baseUrl = 'https://baidu.com';
      final url = '/google';
      final req = Request(HttpMethod.GET, url, baseUrl: baseUrl);
      expect(req.uri.toString(), '$baseUrl$url');
    });

    test("url stared with slash with base url", () async {
      final baseUrl = 'https://baidu.com/';
      final url = '/google';
      final req = Request(HttpMethod.GET, url, baseUrl: baseUrl);
      expect(req.uri.toString(), '$baseUrl$url');
    });

    test("url stared without splash with base url ended without slash",
        () async {
      final baseUrl = 'https://baidu.com';
      final url = 'google';
      final req = Request(HttpMethod.GET, url, baseUrl: baseUrl);
      expect(req.uri.toString(), '$baseUrl/$url');
    });

    test("completed http url without base url", () async {
      final url = 'http://baidu.com';
      final req = Request(HttpMethod.GET, url);
      expect(req.uri.toString(), url);
    });

    test("completed https url with base url", () async {
      final url = 'https://baidu.com';
      final req =
          Request(HttpMethod.GET, url, baseUrl: "http://google.com/hello");
      expect(req.uri.toString(), url);
    });
  });
}
