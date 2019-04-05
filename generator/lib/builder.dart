import 'package:build/build.dart';
import 'src/generator.dart';

Builder retrofitBuilder(BuilderOptions options) =>
    generatorFactoryBuilder(header: options.config["header"] as String);
