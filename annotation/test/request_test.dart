import 'package:retrofit/retrofit.dart';
import 'package:test/test.dart';

void main() {
  group('basic url', () {
    test("url without base url", () async {
      final req = Request(HttpMethod.GET, '/hello');
      expect(req.basicUri.toString(), '/hello');
    });

    test("url with base url", () async {
      final baseUrl = 'https://baidu.com';
      final url = '/google';
      final req = Request(HttpMethod.GET, url, baseUrl: baseUrl);
      expect(req.basicUri.toString(), '$baseUrl$url');
    });

    test("url stared with slash with base url", () async {
      final baseUrl = 'https://baidu.com/';
      final url = '/google';
      final req = Request(HttpMethod.GET, url, baseUrl: baseUrl);
      expect(req.basicUri.toString(), '$baseUrl$url');
    });

    test("url stared without splash with base url ended without slash",
        () async {
      final baseUrl = 'https://baidu.com';
      final url = 'google';
      final req = Request(HttpMethod.GET, url, baseUrl: baseUrl);
      expect(req.basicUri.toString(), '$baseUrl/$url');
    });

    test("completed http url without base url", () async {
      final url = 'http://baidu.com';
      final req = Request(HttpMethod.GET, url);
      expect(req.basicUri.toString(), url);
    });

    test("completed https url with base url", () async {
      final url = 'https://baidu.com';
      final req =
          Request(HttpMethod.GET, url, baseUrl: "http://google.com/hello");
      expect(req.basicUri.toString(), url);
    });
  });
  group('query parameters', () {
    test('basic map queries', () async {
      final queries = {
        'foo': 'bar',
        'age': 1,
        'income': 2.5,
      };
      final req = Request(HttpMethod.GET, '', parameters: queries);

      expect(req.queries, 'foo=bar&age=1&income=2.5');
    });

    test('basic map queries with null value', () async {
      final queries = {'foo': null};
      final req = Request(HttpMethod.GET, '', parameters: queries);

      expect(req.queries, '');
    });

    test('object map in queries', () async {
      final queries = {
        'foo': 'bar',
        'user': {
          'name': 'trevor',
          'age': 1,
        },
      };
      final req = Request(HttpMethod.GET, '', parameters: queries);
      expect(req.queries, 'foo=bar&user.name=trevor&user.age=1');
    });

    test('list in queries', () async {
      final queries = {
        'foo': 'bar',
        'colors': ['red', 'black', 'green'],
      };
      final req = Request(HttpMethod.GET, '', parameters: queries);
      expect(req.queries, 'foo=bar&colors=red&colors=black&colors=green');
    });
  });
}
