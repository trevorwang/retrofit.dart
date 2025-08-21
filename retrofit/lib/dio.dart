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

/// Annotation for cancelling the request.
/// When applied to a parameter, allows the method to accept a [CancelToken] 
/// that can be used to cancel the HTTP request.
@immutable
class CancelRequest {
  const CancelRequest();
}

/// Annotation for tracking download progress.
/// When applied to a parameter, allows the method to accept a callback 
/// function that will be invoked with progress updates during data reception.
@immutable
class ReceiveProgress {
  const ReceiveProgress();
}

/// Annotation for tracking upload progress.
/// When applied to a parameter, allows the method to accept a callback 
/// function that will be invoked with progress updates during data transmission.
@immutable
class SendProgress {
  const SendProgress();
}

/// Annotation to specify the response type for Dio requests.
/// 
/// This allows you to control how Dio processes the response data.
@immutable
class DioResponseType {
  /// Creates a new [DioResponseType] annotation with the specified [responseType].
  ///
  /// [responseType] determines how the response data should be processed:
  /// - [ResponseType.json] - Parse as JSON (default)
  /// - [ResponseType.stream] - Return as stream
  /// - [ResponseType.plain] - Return as plain text
  /// - [ResponseType.bytes] - Return as bytes
  const DioResponseType(this.responseType);

  final ResponseType responseType;
}

/// Wrapper class that combines response data with the raw Dio response.
///
/// This is useful when you need access to both the parsed response data 
/// and the original HTTP response metadata (headers, status code, etc.).
class HttpResponse<T> {
  /// Creates a new [HttpResponse] with the specified [data] and [response].
  ///
  /// * [data] - The parsed response data of type [T]
  /// * [response] - The raw Dio response containing metadata
  HttpResponse(this.data, this.response);

  final T data;
  final Response<dynamic> response;
}

/// Annotation for passing Dio options to individual requests.
/// 
/// When applied to a parameter, allows passing custom [Options] to configure
/// request-specific settings like timeout, headers, or response type.
@immutable
class DioOptions {
  const DioOptions();
}
