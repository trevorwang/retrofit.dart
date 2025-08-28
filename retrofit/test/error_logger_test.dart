import 'package:test/test.dart';
import 'package:retrofit/error_logger.dart';
import 'package:dio/dio.dart';

class TestLogger extends ParseErrorLogger {
  Object? lastError;
  StackTrace? lastStack;
  RequestOptions? lastOptions;

  @override
  void logError(Object error, StackTrace stackTrace, RequestOptions options) {
    lastError = error;
    lastStack = stackTrace;
    lastOptions = options;
  }
}

void main() {
  test('ParseErrorLogger logs error', () {
    final logger = TestLogger();
    final options = RequestOptions(path: '/foo');
    final stack = StackTrace.current;
    logger.logError('err', stack, options);
    expect(logger.lastError, 'err');
    expect(logger.lastStack, stack);
    expect(logger.lastOptions, options);
  });
}
