/// Lean Builder entry point for Retrofit code generator.
///
/// **⚠️ Experimental Feature ⚠️**
///
/// This file provides experimental lean_builder support for retrofit_generator.
/// Lean Builder support is currently under development and not yet recommended
/// for production use.
///
/// ## Important: Optional Dependency
///
/// This library is **NOT** included in retrofit_generator's dependencies.
/// To use lean_builder support, you must add it to your own project:
///
/// ```yaml
/// dependencies:
///   retrofit_generator: <version>
///
/// dev_dependencies:
///   lean_builder: ^0.1.2
/// ```
///
/// Then, in your codegen folder (or where you define generators), import:
/// ```dart
/// import 'package:retrofit_generator/lean_builder.dart';
/// ```
///
/// ## Current Status
///
/// While the infrastructure for lean_builder support has been added, the
/// retrofit_generator package is currently optimized for build_runner. Full
/// lean_builder integration is planned for future releases once lean_builder
/// reaches a stable version.
///
/// ## Usage (Experimental)
///
/// 1. Add both packages to your pubspec.yaml:
/// ```yaml
/// dependencies:
///   retrofit_generator: <version>
///
/// dev_dependencies:
///   lean_builder: ^0.1.2
/// ```
///
/// 2. For now, please continue using build_runner:
/// ```bash
/// dart pub run build_runner build
/// # or for watch mode:
/// dart pub run build_runner watch
/// ```
///
/// ## Future Plans
///
/// Once lean_builder reaches stability and this integration is complete, you'll
/// be able to use:
/// ```bash
/// dart run lean_builder build
/// # or for watch mode with hot reload:
/// dart run lean_builder watch --dev
/// ```
///
/// For updates on lean_builder support, visit:
/// https://github.com/trevorwang/retrofit.dart
library;

export 'package:retrofit_generator/src/lean_generator.dart';
