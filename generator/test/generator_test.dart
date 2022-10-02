import 'dart:async';

import 'package:retrofit/http.dart' as http;
import 'package:retrofit_generator/src/generator.dart';
import 'package:source_gen_test/src/build_log_tracking.dart';
import 'package:source_gen_test/src/init_library_reader.dart';
import 'package:source_gen_test/src/test_annotated_classes.dart';

Future<void> main() async {
  final reader = await initializeLibraryReaderForDirectory(
    'test/src',
    'generator_test_src.dart',
  );
  initializeBuildLogTracking();
  testAnnotatedElements<http.RestApi>(
    reader,
    RetrofitGenerator(RetrofitOptions()),
  );
}
