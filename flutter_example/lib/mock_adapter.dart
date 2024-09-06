import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class MockAdapter extends IOHttpClientAdapter {
  static const String mockHost = 'mockserver';
  static const String mockBase = 'http://$mockHost';
  final _adapter = IOHttpClientAdapter();

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<dynamic>? cancelFuture,
  ) async {
    final uri = options.uri;
    if (uri.host == mockHost) {
      switch (uri.path) {
        case '/tags':
          return ResponseBody.fromString(
            jsonEncode(['tag1', 'tag2']),
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        default:
          return ResponseBody.fromString('', 404);
      }
    }
    return _adapter.fetch(options, requestStream, cancelFuture);
  }

  @override
  void close({bool force = false}) {
    _adapter.close(force: force);
  }
}
