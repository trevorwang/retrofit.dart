# Lean Builder Support (Experimental)

This document provides information about using lean_builder with retrofit_generator.

## Status

⚠️ **Experimental** - Lean Builder support is currently under development and not yet recommended for production use.

## What is Lean Builder?

[Lean Builder](https://pub.dev/packages/lean_builder) is a streamlined Dart build system that offers:
- Fast incremental builds (often under 1 second)
- Parallel processing for maximum efficiency
- Watch mode with hot reload support
- Simple, declarative builder configuration

## Current Implementation

The infrastructure for lean_builder support has been added to retrofit_generator, but the full implementation is pending until:
1. Lean Builder reaches a stable release (currently at v0.1.2)
2. The retrofit_generator codebase is fully adapted to lean_builder's API

## Using build_runner (Recommended)

For now, please continue using build_runner for code generation:

```bash
# One-time build
dart pub run build_runner build

# Watch mode (recommended during development)
dart pub run build_runner watch --delete-conflicting-outputs
```

## Future Usage (When Available)

Once lean_builder support is fully implemented, you'll be able to use:

```bash
# One-time build
dart run lean_builder build

# Watch mode with hot reload
dart run lean_builder watch --dev
```

## Configuration

### pubspec.yaml

**Important**: lean_builder is an **optional** dependency. It is NOT included in retrofit_generator by default.

When lean_builder support is ready, your `pubspec.yaml` will include:

```yaml
dependencies:
  retrofit: ^4.9.0
  dio: ^5.0.0
  json_annotation: ^4.9.0
  retrofit_generator: ^10.0.0  # For use in codegen folder

dev_dependencies:
  lean_builder: ^0.1.2  # Optional - only if you want to use lean_builder
  json_serializable: ^6.10.0
```

Note: retrofit_generator does not depend on lean_builder, so you won't be forced to install it unless you explicitly want to use lean_builder support.

### build.yaml (Optional)

You can keep your existing `build.yaml` configuration. Lean Builder will respect these settings when support is fully implemented:

```yaml
targets:
  $default:
    builders:
      retrofit_generator:
        options:
          auto_cast_response: true
```

## Migration Path

When lean_builder support becomes stable:

1. **No code changes required** - Your @RestApi annotations and API definitions remain the same
2. **Update dependencies** - Add lean_builder to dev_dependencies
3. **Switch build command** - Use `dart run lean_builder build` instead of `build_runner`
4. **Enjoy faster builds** - Experience significantly faster incremental builds

## Contributing

If you're interested in helping complete the lean_builder integration, please:
1. Check the [retrofit.dart GitHub repository](https://github.com/trevorwang/retrofit.dart)
2. Review the [lean_builder documentation](https://pub.dev/packages/lean_builder)
3. Submit a pull request or open an issue with your ideas

## Support

For questions or issues:
- **retrofit.dart**: https://github.com/trevorwang/retrofit.dart/issues
- **lean_builder**: https://github.com/Milad-Akarie/lean_builder/issues

## Timeline

Follow the retrofit.dart repository for updates on when lean_builder support will be fully available. The maintainers are monitoring lean_builder's development and will complete the integration when appropriate.
