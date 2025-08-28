import 'package:build/build.dart';
import 'package:retrofit_generator/src/generator.dart';

/// Entry point for the Retrofit code generator for build_runner.
Builder retrofitBuilder(BuilderOptions options) =>
    generatorFactoryBuilder(options);
