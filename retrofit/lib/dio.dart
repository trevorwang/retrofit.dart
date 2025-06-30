import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

/// Extra data that will be passed to Dio's request, response, transformer, and interceptors.
/// Extend [TypedExtras] and define fields that correspond to the keys passed into `extras`.
/// The values of these fields will be derived from the data passed into your subclass.
///
/// Example:
///
/// ```dart
/// @TypedExtrasSubClass(
///   id: '1234',
///   fileType: '.json',
/// )
/// @GET("/get")
/// Future<String> foo();
/// ```
///
@immutable
class TypedExtras {
  const TypedExtras();
}

/// Extra data that will be passed to dio's request, response, transformer and interceptors.
@immutable
class Extra {
  /// Extra data that will be passed to dio's request, response, transformer and interceptors.
  const Extra(this.data);

  final Map<String, Object> data;
}

/// Extra data that will be passed to dio's request, response, transformer and interceptors.
/// Simple Example:
///
/// ```dart
/// @GET("/get")
/// Future<String> foo(@Extras() Map<String, dynamic> extras)
/// ```
@immutable
class Extras {
  const Extras();
}

@immutable
class CancelRequest {
  const CancelRequest();
}

@immutable
class ReceiveProgress {
  const ReceiveProgress();
}

@immutable
class SendProgress {
  const SendProgress();
}

@immutable
class DioResponseType {
  const DioResponseType(this.responseType);

  final ResponseType responseType;
}

class HttpResponse<T> {
  HttpResponse(this.data, this.response);

  final T data;
  final Response<dynamic> response;
}

@immutable
class DioOptions {
  const DioOptions();
}
