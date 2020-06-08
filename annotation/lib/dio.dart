import 'package:meta/meta.dart';
import 'package:dio/dio.dart';

/// Extra data that will be passed to dio's request, response, transformer and interceptors.
@immutable
class Extra {
  final Map<String, Object> data;

  /// Extra data that will be passed to dio's request, response, transformer and interceptors.
  const Extra(this.data);
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
  final ResponseType responseType;
  const DioResponseType(this.responseType);
}

class HttpResponse<T> {
  final T data;
  final Response response;
  HttpResponse(this.data, this.response);
}

@immutable
class DioOptions {
  const DioOptions();
}

RequestOptions newRequestOptions(Options options) {
  if (options is RequestOptions) {
    return options;
  }
  if (options == null) {
    return RequestOptions();
  }
  return RequestOptions(
    method: options.method,
    sendTimeout: options.sendTimeout,
    receiveTimeout: options.receiveTimeout,
    extra: options.extra,
    headers: options.headers,
    responseType: options.responseType,
    contentType: options.contentType.toString(),
    validateStatus: options.validateStatus,
    receiveDataWhenStatusError: options.receiveDataWhenStatusError,
    followRedirects: options.followRedirects,
    maxRedirects: options.maxRedirects,
    requestEncoder: options.requestEncoder,
    responseDecoder: options.responseDecoder,
  );
}
