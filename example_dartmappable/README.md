# Dart Mappable Example

This example demonstrates how to use `dart_mappable` with Retrofit for type conversion.

## Setup

1. Add the required dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  retrofit: ^4.9.0
  dio: ^5.7.0
  dart_mappable: ^4.2.0

dev_dependencies:
  retrofit_generator: ^10.0.1
  build_runner: ^2.4.0
  dart_mappable_builder: ^4.2.0
```

2. Define your models with `@MappableClass()`:

```dart
import 'package:dart_mappable/dart_mappable.dart';

part 'example.mapper.dart';

@MappableClass()
class Task with TaskMappable {
  const Task({
    this.id,
    this.name,
    this.avatar,
    this.createdAt,
  });

  final String? id;
  final String? name;
  final String? avatar;
  final String? createdAt;
}
```

3. Create your API client with `Parser.DartMappable`:

```dart
import 'package:retrofit/retrofit.dart';

part 'example.g.dart';

@RestApi(
  baseUrl: 'https://api.example.com',
  parser: Parser.DartMappable,
)
abstract class ApiService {
  factory ApiService(Dio dio) = _ApiService;

  @GET('/tasks')
  Future<List<Task>> getTasks();
}
```

4. Generate code:

```bash
dart run build_runner build
```

## Running the Example

```bash
dart run bin/main.dart
```
