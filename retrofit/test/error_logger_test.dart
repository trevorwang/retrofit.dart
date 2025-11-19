import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:test/test.dart';

class TestLogger extends ParseErrorLogger {
  Object? lastError;
  StackTrace? lastStack;
  RequestOptions? lastOptions;
  Response? lastResponse;

  @override
  void logError(Object error, StackTrace stackTrace, RequestOptions options, Response response) {
    lastError = error;
    lastStack = stackTrace;
    lastOptions = options;
    lastResponse = response;
  }
}

void main() {
  test('ParseErrorLogger logs error', () {
    final logger = TestLogger();
    final options = RequestOptions(path: '/foo');
    final response = Response(requestOptions: options, statusCode: 200);
    final stack = StackTrace.current;
    logger.logError('err', stack, options, response);
    expect(logger.lastError, 'err');
    expect(logger.lastStack, stack);
    expect(logger.lastOptions, options);
    expect(logger.lastResponse, response);
  });
}
