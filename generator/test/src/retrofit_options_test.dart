import 'package:test/test.dart';
import 'package:retrofit_generator/src/generator.dart';

void main() {
  group('RetrofitOptions', () {
    test('default constructor', () {
      final opts = RetrofitOptions();
      expect(opts.autoCastResponse, isNull);
      expect(opts.emptyRequestBody, isNull);
      expect(opts.className, isNull);
      expect(opts.useResult, isNull);
    });

    test('fromOptions parses bools and strings', () {
      final opts = RetrofitOptions.fromOptions(null);
      expect(opts.autoCastResponse, true);
      expect(opts.emptyRequestBody, false);
      expect(opts.className, isNull);
      expect(opts.useResult, false);

      final opts2 = RetrofitOptions.fromOptions({
        'auto_cast_response': 'false',
        'empty_request_body': 'true',
        'class-name': 'Foo',
        'use_result': 'true',
      });
      expect(opts2.autoCastResponse, false);
      expect(opts2.emptyRequestBody, true);
      expect(opts2.className, 'Foo');
      expect(opts2.useResult, true);
    });
  });
}
