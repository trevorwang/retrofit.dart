import 'package:build/build.dart';
import 'package:retrofit_generator/src/generator.dart';

/// Builds generators for `build_runner` to run
Builder retrofitBuilder(BuilderOptions options) =>
    generatorFactoryBuilder(options);
