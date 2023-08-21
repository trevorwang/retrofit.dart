import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

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
