import 'package:meta/meta.dart';

/// A holder that includes all http methods which are supported by retrofit.
class HttpMethod {
  static const String GET = "GET";
  static const String POST = "POST";
  static const String PATCH = "PATCH";
  static const String PUT = "PUT";
  static const String DELETE = "DELETE";
  static const String HEAD = "HEAD";
  static const String OPTIONS = "OPTIONS";
}

/// Define how to parse response json
/// If you want to support more, PR is welcome
enum Parser {
  /// Each model class must provide 'factory T.fromJson(Map<String, dynamic> json)'
  /// For more detail, please visit 'https://github.com/trevorwang/retrofit.dart#type-conversion'
  JsonSerializable,

  /// same as [JsonSerializable] but with toMap and fromMap functions.
  MapSerializable,

  /// Each model class must add annotation '@jsonSerializable'
  /// For more detail, please visit 'https://github.com/k-paxian/dart-json-mapper'
  DartJsonMapper
}

/// Define an API.
@immutable
class RestApi {
  /// Set the API base URL.
  ///
  /// Base URLs should always end in `/`.
  ///
  /// __Correct:__
  ///
  /// * Base URL: `http://example.com/api/`
  /// * Endpoint: `foo/bar/`
  /// * Result: `http://example.com/api/foo/bar/`
  ///
  /// __Incorrect:__
  ///
  /// * Base URL: `http://example.com/api`
  /// * Endpoint: `foo/bar/`
  /// * Result: `http://example.com/foo/bar/`
  ///
  /// When you don't specify the [baseUrl]. The [dio] instance passed to the constructor should have it defined.
  /// Otherwise the `path` field of any [HttpMethod] like [POST] should have the full URL.

  final String? baseUrl;

  /// if you don't specify the [parser]. It will be [Parser.JsonSerializable]
  final Parser? parser;

  const RestApi({this.baseUrl, this.autoCastResponse, this.parser});

  /// Automatically cast response to proper type for all methods in this client
  ///
  /// This is experimental, Currently there's no perfect solution for this.
  @experimental
  final bool? autoCastResponse;
}

@immutable
class Method {
  /// HTTP request method which can be found in [HttpMethod].
  final String method;

  /// A relative or absolute path, or full URL of the endpoint.
  ///
  /// See [RestApi.baseUrl] for details of how this is resolved against a base URL
  /// to create the full endpoint URL.
  final String path;
  const Method(
    this.method,
    this.path, {
    this.autoCastResponse = true,
  });

  /// Automatically cast response to proper type for this method only
  ///
  /// This is experimental, Currently there's no perfect solution for this.
  @experimental
  @Deprecated(
      "Use `HttpResponse` to get the original response, will be removed in the future release.")
  final bool autoCastResponse;
}

/// Make a `GET` request
///
/// ```
/// @GET("ip")
/// Future<String> ip(@Query('query1') String query)
/// ```
@immutable
class GET extends Method {
  const GET(String path, {bool autoCastResponse = true})
      : super(HttpMethod.GET, path, autoCastResponse: autoCastResponse);
}

/// Make a `POST` request
@immutable
class POST extends Method {
  const POST(String path, {bool autoCastResponse = true})
      : super(HttpMethod.POST, path, autoCastResponse: autoCastResponse);
}

/// Make a `PATCH` request
@immutable
class PATCH extends Method {
  const PATCH(final String path, {bool autoCastResponse = true})
      : super(HttpMethod.PATCH, path, autoCastResponse: autoCastResponse);
}

/// Make a `PUT` request
@immutable
class PUT extends Method {
  const PUT(final String path, {bool autoCastResponse = true})
      : super(HttpMethod.PUT, path, autoCastResponse: autoCastResponse);
}

/// Make a `DELETE` request
@immutable
class DELETE extends Method {
  const DELETE(final String path, {bool autoCastResponse = true})
      : super(HttpMethod.DELETE, path, autoCastResponse: autoCastResponse);
}

/// Make a `HEAD` request
@immutable
class HEAD extends Method {
  const HEAD(String path, {bool autoCastResponse = true})
      : super(HttpMethod.HEAD, path, autoCastResponse: autoCastResponse);
}

/// Make a `OPTIONS` request
@immutable
class OPTIONS extends Method {
  const OPTIONS(String path, {bool autoCastResponse = true})
      : super(HttpMethod.OPTIONS, path, autoCastResponse: autoCastResponse);
}

/// Adds headers specified in the [value] map.
@immutable
class Headers {
  final Map<String, dynamic>? value;
  const Headers([this.value]);
}

/// Replaces the header with the value of its target.
///
/// Header parameters may be `null` which will omit them from the request.
@immutable
class Header {
  final String value;
  const Header(this.value);
}

/// Use this annotation on a service method param when you want to directly control the request body
/// of a POST/PUT request (instead of sending in as request parameters or form-style request
/// body).
///
/// Body parameters may not be `null`.
@immutable
class Body {
  const Body();
}

/// Named pair for a form request.
///
/// ```
/// @POST("/post")
/// Future<String> example(
///   @Field() int foo,
///   @Field("bar") String barbar},
/// )
/// ```
/// Calling with `foo.example("Bob Smith", "President")` yields a request body of
/// `foo=Bob+Smith&bar=President`.
@immutable
class Field {
  final String? value;
  const Field([this.value]);
}

/// Named replacement in a URL path segment.
///
/// Path parameters may not be `null`.
@immutable
class Path {
  final String? value;
  const Path([this.value]);
}

/// Query parameter appended to the URL.
///
/// Simple Example:
///
///```
/// @GET("/get")
/// Future<String> foo(@Query('bar') String query)
///```
/// Calling with `foo.friends(1)` yields `/get?bar=1`.
@immutable
class Query {
  final String value;
  final bool encoded;
  const Query(this.value, {this.encoded = false});
}

/// Query parameter keys and values appended to the URL.
///
/// A `null` value for the map, as a key, or as a value is not allowed.
@immutable
class Queries {
  final bool encoded;
  const Queries({this.encoded = false});
}

/// Denotes that the request body will use form URL encoding. Fields should be declared as
/// parameters and annotated with [Field].
///
/// Requests made with this annotation will have `application/x-www-form-urlencoded` MIME
/// type. Field names and values will be UTF-8 encoded before being URI-encoded in accordance to
/// [RFC-3986](http://tools.ietf.org/html/rfc3986)
@immutable
class FormUrlEncoded {
  final mime = 'application/x-www-form-urlencoded';
  const FormUrlEncoded();
}

/// Denotes that the request body is multi-part. Parts should be declared as parameters and
/// annotated with [Part].
@immutable
class MultiPart {
  const MultiPart();
}

/// Denotes a single part of a multi-part request.
/// Part parameters may not be null.
/// ```
/// @POST("/post")
/// @MultiPart()
/// Future<String> example(
///   @Part() int foo,
///   { @Part(name: "bar") String barbar,
///     @Part(contentType:'application/json') File file
///   },
/// )
/// ```
@immutable
class Part {
  @Deprecated('future release')
  final String? value;
  final String? name;

  /// If this field is a file, optionally specify it's name. otherwise the name
  /// will be derived from the actual file.
  final String? fileName;

  // To identify the content type of a file
  final String? contentType;
  const Part({this.value, this.name, this.fileName, this.contentType});
}
