import 'package:build/build.dart';
import 'package:retrofit/retrofit.dart' as retrofit;
import 'package:retrofit_generator/src/generator.dart';
import 'package:test/test.dart';

void main() {
  group('RetrofitOptions - parser configuration', () {
    test('parser defaults to null when not specified in BuilderOptions', () {
      final options = RetrofitOptions.fromOptions();
      expect(options.parser, isNull);

      final emptyOptions = RetrofitOptions.fromOptions(BuilderOptions({}));
      expect(emptyOptions.parser, isNull);
    });

    test('parser is null when option value is empty or whitespace', () {
      final emptyStrOptions = RetrofitOptions.fromOptions(
        BuilderOptions({'parser': ''}),
      );
      expect(emptyStrOptions.parser, isNull);

      final whitespaceOptions = RetrofitOptions.fromOptions(
        BuilderOptions({'parser': '   '}),
      );
      expect(whitespaceOptions.parser, isNull);
    });

    test('parses snake_case parser options correctly', () {
      expect(
        RetrofitOptions.fromOptions(
          BuilderOptions({'parser': 'dart_mappable'}),
        ).parser,
        equals(retrofit.Parser.DartMappable),
      );
      expect(
        RetrofitOptions.fromOptions(
          BuilderOptions({'parser': 'json_serializable'}),
        ).parser,
        equals(retrofit.Parser.JsonSerializable),
      );
      expect(
        RetrofitOptions.fromOptions(
          BuilderOptions({'parser': 'map_serializable'}),
        ).parser,
        equals(retrofit.Parser.MapSerializable),
      );
      expect(
        RetrofitOptions.fromOptions(
          BuilderOptions({'parser': 'dart_json_mapper'}),
        ).parser,
        equals(retrofit.Parser.DartJsonMapper),
      );
      expect(
        RetrofitOptions.fromOptions(
          BuilderOptions({'parser': 'flutter_compute'}),
        ).parser,
        equals(retrofit.Parser.FlutterCompute),
      );
    });

    test('parses PascalCase and camelCase parser options correctly', () {
      expect(
        RetrofitOptions.fromOptions(
          BuilderOptions({'parser': 'DartMappable'}),
        ).parser,
        equals(retrofit.Parser.DartMappable),
      );
      expect(
        RetrofitOptions.fromOptions(
          BuilderOptions({'parser': 'dartMappable'}),
        ).parser,
        equals(retrofit.Parser.DartMappable),
      );
      expect(
        RetrofitOptions.fromOptions(
          BuilderOptions({'parser': 'JsonSerializable'}),
        ).parser,
        equals(retrofit.Parser.JsonSerializable),
      );
      expect(
        RetrofitOptions.fromOptions(
          BuilderOptions({'parser': 'MapSerializable'}),
        ).parser,
        equals(retrofit.Parser.MapSerializable),
      );
      expect(
        RetrofitOptions.fromOptions(
          BuilderOptions({'parser': 'DartJsonMapper'}),
        ).parser,
        equals(retrofit.Parser.DartJsonMapper),
      );
      expect(
        RetrofitOptions.fromOptions(
          BuilderOptions({'parser': 'FlutterCompute'}),
        ).parser,
        equals(retrofit.Parser.FlutterCompute),
      );
    });

    test('handles leading/trailing whitespace and case-insensitivity', () {
      expect(
        RetrofitOptions.fromOptions(
          BuilderOptions({'parser': '  DART_MAPPABLE  '}),
        ).parser,
        equals(retrofit.Parser.DartMappable),
      );
    });

    test('throws ArgumentError for invalid parser option', () {
      expect(
        () => RetrofitOptions.fromOptions(
          BuilderOptions({'parser': 'unknown_parser'}),
        ),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('Unsupported parser option'),
          ),
        ),
      );
    });

    test('RetrofitOptions constructor accepts explicit parser', () {
      final options = RetrofitOptions(parser: retrofit.Parser.DartMappable);
      expect(options.parser, equals(retrofit.Parser.DartMappable));
    });
  });
}
