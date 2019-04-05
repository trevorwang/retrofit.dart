import 'package:meta/meta.dart';

class HttpMethod {
  static const String GET = "GET";
  static const String POST = "POST";
  static const String PATCH = "PATCH";
  static const String PUT = "PUT";
  static const String DELETE = "DELETE";
}

@immutable
class RestApi {
  final String baseUrl;
  const RestApi({this.baseUrl: "/"});
}

@immutable
class Method {
  final String method;
  final String path;
  const Method(this.method, this.path);
}

@immutable
class GET extends Method {
  const GET(String path) : super(HttpMethod.GET, path);
}

@immutable
class POST extends Method {
  const POST(String path) : super(HttpMethod.POST, path);
}

@immutable
class PATCH extends Method {
  const PATCH(final String path) : super(HttpMethod.PATCH, path);
}

@immutable
class PUT extends Method {
  const PUT(final String path) : super(HttpMethod.PUT, path);
}

@immutable
class DELETE extends Method {
  const DELETE(final String path) : super(HttpMethod.DELETE, path);
}

@immutable
class Headers {
  final Map<String, dynamic> value;
  const Headers([this.value]);
}

@immutable
class Header {
  final String value;
  const Header(this.value);
}

// @immutable
// class HeaderMap {
//   const HeaderMap();
// }

@immutable
class Body {
  const Body();
}

@immutable
class Field {
  final String value;
  const Field([this.value]);
}

@immutable
class Path {
  final String value;
  const Path([this.value]);
}

@immutable
class Query {
  final String value;
  final bool encoded;
  const Query(this.value, {this.encoded = false});
}

@immutable
class QueryMap {
  final bool encoded;
  const QueryMap({this.encoded = false});
}

// @immutable
// class QueryName {
//   final String value;
//   final bool encoded;
//   const QueryName(this.value, {this.encoded});
// }
