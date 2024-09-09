import 'package:dio/dio.dart';

/// Base class for logging errors that occur during parsing of response data.
abstract class ParseErrorLogger {
  /// Logs an error that occurred during parsing of response data.
  ///
  /// - [error] is the error that occurred.
  /// - [stackTrace] is the stack trace of the error.
  /// - [options] are the options that were used to make the request.
  void logError(Object error, StackTrace stackTrace, RequestOptions options);
}
