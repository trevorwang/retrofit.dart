import 'package:meta/meta.dart';

/// Extra data that will be passed to dio's request, response, transformer and interceptors.
@immutable
class Extra {
  final Map<String, Object> data;

  /// Extra data that will be passed to dio's request, response, transformer and interceptors.
  const Extra(this.data);
}
