import 'dart:async';

import 'package:lean_builder/builder.dart';
import 'package:lean_builder/element.dart';
import 'package:retrofit/retrofit.dart' as retrofit;

/// Lean Builder generator for Retrofit.
///
/// This generator provides lean_builder support for retrofit_generator,
/// allowing faster incremental builds with lean_builder.
///
/// Note: This is an experimental feature. For production use, we recommend
/// using the traditional build_runner approach until lean_builder support
/// is fully stable.
///
/// This generator is automatically discovered by lean_builder through the
/// @LeanGenerator.shared() annotation, which marks it as a shared part builder
/// (similar to build_runner's shared part builders).
@LeanGenerator.shared()
class RetrofitLeanGenerator extends GeneratorForAnnotatedClass<retrofit.RestApi> {
  RetrofitLeanGenerator();

  @override
  FutureOr<String?> generateForClass(
    BuildStep buildStep,
    ClassElement classElement,
    ElementAnnotation annotation,
  ) async {
    // The retrofit generator is currently optimized for build_runner/source_gen.
    // Full lean_builder support requires adapting the codebase to use lean_builder's
    // analyzer abstractions instead of source_gen's API.
    //
    // For now, this serves as a placeholder for future lean_builder support.
    // Users should continue using build_runner for code generation:
    //   dart pub run build_runner build
    
    throw UnsupportedError(
      'Lean Builder support for retrofit_generator is not yet fully implemented.\n'
      'The retrofit_generator package currently works with build_runner.\n\n'
      'To generate code, please use:\n'
      '  dart pub run build_runner build\n\n'
      'For more information, see: https://github.com/trevorwang/retrofit.dart\n\n'
      'Lean Builder support is planned for a future release once lean_builder reaches stable.',
    );
  }
}
