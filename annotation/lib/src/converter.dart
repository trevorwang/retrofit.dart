import 'dart:convert';

import 'request.dart';
import 'response.dart';
import 'utils.dart';

abstract class Converter<T> {
  Request convertRequest(Request request) {
    return request;
  }

  Response<T> convertResponse<T, I>(Response response);
}

class JsonConverter<T> extends Converter<T> {
  @override
  Request convertRequest(Request request) {
    return request;
  }

  @override
  Response<T> convertResponse<T, I>(Response response) {
    dynamic body = response.body;
    body = utf8.decode(body);
    body = _tryDecodeJson(body);
    if (isTypeOf<T, Iterable<I>>()) {
      body = body.cast<I>();
    } else if (isTypeOf<T, Map<String, I>>()) {
      body = body.cast<String, I>();
    }
    return response.copyWith<T>(body: body);
  }

  dynamic _tryDecodeJson(String data) {
    try {
      return json.decode(data);
    } catch (e) {
      logger.warning(e);
      return data;
    }
  }
}
