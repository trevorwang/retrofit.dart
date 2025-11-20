import 'package:build/build.dart';
import 'package:retrofit_generator/src/generator.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

void main() {
  group('RetrofitOptions', () {
    test('formatOutput defaults to true when not specified', () {
      final options = RetrofitOptions.fromOptions();
      expect(options.formatOutput, isTrue);
    });

    test('formatOutput is true when explicitly set to true', () {
      final builderOptions = BuilderOptions({
        'format_output': 'true',
      });
      final options = RetrofitOptions.fromOptions(builderOptions);
      expect(options.formatOutput, isTrue);
    });

    test('formatOutput is false when explicitly set to false', () {
      final builderOptions = BuilderOptions({
        'format_output': 'false',
      });
      final options = RetrofitOptions.fromOptions(builderOptions);
      expect(options.formatOutput, isFalse);
    });

    test('formatOutput handles non-boolean string values', () {
      final builderOptions = BuilderOptions({
        'format_output': 'False',
      });
      final options = RetrofitOptions.fromOptions(builderOptions);
      // Should be false because it's not exactly 'true'
      expect(options.formatOutput, isFalse);
    });
  });

  group('generatorFactoryBuilder', () {
    test('creates builder with default format_output option', () {
      final builderOptions = BuilderOptions({});
      final builder = generatorFactoryBuilder(builderOptions);
      expect(builder, isNotNull);
      expect(builder, isA<SharedPartBuilder>());
    });

    test('creates builder with format_output set to false', () {
      final builderOptions = BuilderOptions({
        'format_output': 'false',
      });
      final builder = generatorFactoryBuilder(builderOptions);
      expect(builder, isNotNull);
      expect(builder, isA<SharedPartBuilder>());
    });

    test('creates builder with format_output set to true', () {
      final builderOptions = BuilderOptions({
        'format_output': 'true',
      });
      final builder = generatorFactoryBuilder(builderOptions);
      expect(builder, isNotNull);
      expect(builder, isA<SharedPartBuilder>());
    });
  });
}
