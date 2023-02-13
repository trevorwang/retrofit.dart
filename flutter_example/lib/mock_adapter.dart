import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:diox/diox.dart';

class MockAdapter implements HttpClientAdapter {
  static const String mockHost = "mockserver";
  static const String mockBase = "http://$mockHost";
  HttpClientAdapter _adapter = HttpClientAdapter();

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future? cancelFuture) async {
    Uri uri = options.uri;
    if (uri.host == mockHost) {
      switch (uri.path) {
        case "/tags":
          return ResponseBody.fromString(
            jsonEncode(["tag1", "tag2"]),
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        default:
          return ResponseBody.fromString("", 404);
      }
    }
    return _adapter.fetch(options, requestStream, cancelFuture);
  }

  @override
  void close({bool force = false}) {
    _adapter.close(force: force);
  }
}
