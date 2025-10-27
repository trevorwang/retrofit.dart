import 'package:test/test.dart';
import 'package:retrofit/http.dart';

void main() {
  group('HttpMethod', () {
    test('contains standard HTTP methods', () {
      expect(HttpMethod.GET, 'GET');
      expect(HttpMethod.POST, 'POST');
      expect(HttpMethod.PATCH, 'PATCH');
      expect(HttpMethod.PUT, 'PUT');
      expect(HttpMethod.DELETE, 'DELETE');
      expect(HttpMethod.HEAD, 'HEAD');
      expect(HttpMethod.OPTIONS, 'OPTIONS');
    });
  });

  group('Parser', () {
    test('enum values', () {
      expect(Parser.values, contains(Parser.JsonSerializable));
      expect(Parser.values, contains(Parser.MapSerializable));
      expect(Parser.values, contains(Parser.DartJsonMapper));
      expect(Parser.values, contains(Parser.FlutterCompute));
    });
  });

  group('RestApi', () {
    test('default values', () {
      const api = RestApi();
      expect(api.baseUrl, isNull);
      expect(api.parser, Parser.JsonSerializable);
      expect(api.callAdapter, isNull);
    });
    test('custom values', () {
      const api = RestApi(
          baseUrl: 'http://foo/',
          parser: Parser.MapSerializable,
          callAdapter: int);
      expect(api.baseUrl, 'http://foo/');
      expect(api.parser, Parser.MapSerializable);
      expect(api.callAdapter, int);
    });
  });

  group('Method annotations', () {
    test('GET/POST/PATCH/PUT/DELETE/HEAD/OPTIONS', () {
      expect(const GET('/foo').method, 'GET');
      expect(const POST('/foo').method, 'POST');
      expect(const PATCH('/foo').method, 'PATCH');
      expect(const PUT('/foo').method, 'PUT');
      expect(const DELETE('/foo').method, 'DELETE');
      expect(const HEAD('/foo').method, 'HEAD');
      expect(const OPTIONS('/foo').method, 'OPTIONS');
    });
    test('Method path', () {
      expect(const GET('/bar').path, '/bar');
    });
  });

  group('Headers/Field/Path/Query/Queries', () {
    test('Headers', () {
      expect(const Headers({'foo': 'bar'}).value, {'foo': 'bar'});
      expect(const Headers().value, isNull);
    });
    test('Field', () {
      expect(const Field('foo').value, 'foo');
      expect(const Field().value, isNull);
    });
    test('Path', () {
      expect(const Path('id').value, 'id');
      expect(const Path().value, isNull);
    });
    test('Query', () {
      expect(const Query('foo').value, 'foo');
      expect(const Query('foo', encoded: true).encoded, true);
    });
    test('Queries', () {
      expect(const Queries().encoded, false);
      expect(const Queries(encoded: true).encoded, true);
    });
  });

  group('Body/BodyExtra/NoBody', () {
    test('Body', () {
      expect(const Body().nullToAbsent, false);
      expect(const Body(nullToAbsent: true).nullToAbsent, true);
    });
    test('BodyExtra', () {
      expect(const BodyExtra('foo').value, 'foo');
      expect(const BodyExtra('foo', expand: true).expand, true);
    });
    test('NoBody', () {
      expect(const NoBody(), isA<NoBody>());
    });
  });

  group('FormUrlEncoded/MultiPart/Part', () {
    test('FormUrlEncoded', () {
      expect(const FormUrlEncoded().mime, 'application/x-www-form-urlencoded');
    });
    test('MultiPart', () {
      expect(const MultiPart().mime, 'multipart/form-data');
    });
    test('Part', () {
      final part =
          Part(name: 'file', fileName: 'a.txt', contentType: 'text/plain');
      expect(part.name, 'file');
      expect(part.fileName, 'a.txt');
      expect(part.contentType, 'text/plain');
    });
  });

  group('CacheControl', () {
    test('default values', () {
      const cache = CacheControl();
      expect(cache.maxAge, isNull);
      expect(cache.noCache, false);
      expect(cache.other, isEmpty);
    });
    test('custom values', () {
      const cache = CacheControl(maxAge: 10, noCache: true, other: ['foo']);
      expect(cache.maxAge, 10);
      expect(cache.noCache, true);
      expect(cache.other, ['foo']);
    });
  });

  group('PreventNullToAbsent', () {
    test('is const', () {
      expect(const PreventNullToAbsent(), isA<PreventNullToAbsent>());
    });
  });
}
