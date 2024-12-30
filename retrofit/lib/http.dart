// ignore_for_file: constant_identifier_names
import 'package:meta/meta.dart';

/// A holder that includes all http methods which are supported by retrofit.
class HttpMethod {
  static const String GET = 'GET';
  static const String POST = 'POST';
  static const String PATCH = 'PATCH';
  static const String PUT = 'PUT';
  static const String DELETE = 'DELETE';
  static const String HEAD = 'HEAD';
  static const String OPTIONS = 'OPTIONS';
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
  DartJsonMapper,

  /// Parse on a separate isolate using `compute` (Flutter only).
  ///
  /// Each model class must define a top-level function, taking the form
  /// ```
  /// FutureOr<T> deserializeT(Map<String, dynamic> json);
  /// FutureOr<dynamic> serializeTask(T object);
  /// ```
  ///
  /// If you want to handle lists of objects, either as return types or parameters, you should provide List counterparts.
  ///
  /// ```
  /// FutureOr<List<T>> deserializeTList(Map<String, dynamic> json);
  /// FutureOr<dynamic> serializeTList(List<T> objects);
  /// ```
  ///
  /// E.g.
  /// ----
  /// _In file user.dart_
  /// ```
  /// User deserializeUser(Map<String, dynamic> json) => User.fromJson(json);
  /// List<User> deserializeUserList(List<Map<String, dynamic>> json) =>
  ///     json.map((e) => User.fromJson(e)).toList();
  /// Map<String, dynamic> serializeUser(User object) => object.toJson();
  /// List<Map<String, dynamic>> serializeUserList(List<User> objects) =>
  ///     objects.map((e) => e.toJson()).toList();
  ///
  /// @JsonSerializable()
  /// class User {
  ///   factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  ///   Map<String, dynamic> toJson() => _$UserToJson(this);
  /// }
  /// ```
  FlutterCompute,
}

/// Define an API.
@immutable
class RestApi {
  const RestApi({
    this.baseUrl,
    this.parser = Parser.JsonSerializable,
  });

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
  /// When you specify a relative [baseUrl]. The [Dio] instance passed to the constructor should have it defined.
  /// When you don't specify the [baseUrl]. The [Dio] instance passed to the constructor should have it defined.
  /// Otherwise the `path` field of any [HttpMethod] like [POST] should have the full URL.

  final String? baseUrl;

  /// if you don't specify the [parser]. It will be [Parser.JsonSerializable]
  final Parser parser;
}

@immutable
class Method {
  const Method(
    this.method,
    this.path,
  );

  /// HTTP request method which can be found in [HttpMethod].
  final String method;

  /// A relative or absolute path, or full URL of the endpoint.
  ///
  /// See [RestApi.baseUrl] for details of how this is resolved against a base URL
  /// to create the full endpoint URL.
  final String path;
}

/// Make a `GET` request
///
/// ```
/// @GET("ip")
/// Future<String> ip(@Query('query1') String query)
/// ```
@immutable
class GET extends Method {
  const GET(String path) : super(HttpMethod.GET, path);
}

/// Make a `POST` request
@immutable
class POST extends Method {
  const POST(String path) : super(HttpMethod.POST, path);
}

/// Make a `PATCH` request
@immutable
class PATCH extends Method {
  const PATCH(final String path) : super(HttpMethod.PATCH, path);
}

/// Make a `PUT` request
@immutable
class PUT extends Method {
  const PUT(final String path) : super(HttpMethod.PUT, path);
}

/// Make a `DELETE` request
@immutable
class DELETE extends Method {
  const DELETE(final String path) : super(HttpMethod.DELETE, path);
}

/// Make a `HEAD` request
@immutable
class HEAD extends Method {
  const HEAD(String path) : super(HttpMethod.HEAD, path);
}

/// Make a `OPTIONS` request
@immutable
class OPTIONS extends Method {
  const OPTIONS(String path) : super(HttpMethod.OPTIONS, path);
}

/// Adds headers specified in the [value] map.
@immutable
class Headers {
  const Headers([this.value]);

  final Map<String, dynamic>? value;
}

/// Replaces the header with the value of its target.
///
/// Header parameters may be `null` which will omit them from the request.
@immutable
class Header {
  const Header(this.value);

  final String value;
}

/// Use this annotation on a service method param when you want to directly control the request body
/// of a POST/PUT request (instead of sending in as request parameters or form-style request
/// body).
///
/// Body parameters may not be `null`.
@immutable
class Body {
  const Body({this.nullToAbsent = false});

  final bool nullToAbsent;
}

/// Use this annotation on a service method param when you want to indicate that no body should be
/// generated for POST/PUT/DELETE requests.
@immutable
class NoBody {
  const NoBody();
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
  const Field([this.value]);

  final String? value;
}

/// Named replacement in a URL path segment.
///
/// Path parameters may not be `null`.
@immutable
class Path {
  const Path([this.value]);

  final String? value;
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
  const Query(this.value, {this.encoded = false});

  final String value;
  final bool encoded;
}

/// Query parameter keys and values appended to the URL.
///
/// A `null` value for the map, as a key, or as a value is not allowed.
@immutable
class Queries {
  const Queries({this.encoded = false});

  final bool encoded;
}

/// An interface for annotation which has mime type.
/// Such as [FormUrlEncoded] and [MultiPart].
abstract class _MimeType {
  const _MimeType();

  abstract final String mime;
}

/// Denotes that the request body will use form URL encoding. Fields should be declared as
/// parameters and annotated with [Field].
///
/// Requests made with this annotation will have `application/x-www-form-urlencoded` MIME
/// type. Field names and values will be UTF-8 encoded before being URI-encoded in accordance to
/// [RFC-3986](http://tools.ietf.org/html/rfc3986)
@immutable
class FormUrlEncoded extends _MimeType {
  const FormUrlEncoded();

  @override
  final String mime = 'application/x-www-form-urlencoded';
}

/// Denotes that the request body is multi-part. Parts should be declared as parameters and
/// annotated with [Part].
@immutable
class MultiPart extends _MimeType {
  const MultiPart();

  @override
  final String mime = 'multipart/form-data';
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
  const Part({
    @Deprecated('future release') this.value,
    this.name,
    this.fileName,
    this.contentType,
  });

  @Deprecated('future release')
  final String? value;
  final String? name;

  /// If this field is a file, optionally specify it's name. otherwise the name
  /// will be derived from the actual file.
  final String? fileName;

  // To identify the content type of a file
  final String? contentType;
}

@immutable
class CacheControl {
  const CacheControl({
    this.maxAge,
    this.maxStale,
    this.minFresh,
    this.noCache = false,
    this.noStore = false,
    this.noTransform = false,
    this.onlyIfCached = false,
    this.other = const [],
  });

  final int? maxAge;
  final int? maxStale;
  final int? minFresh;
  final bool noCache;
  final bool noStore;
  final bool noTransform;
  final bool onlyIfCached;
  final List<String> other;
}

/// Prevents `null` values from being converted to `absent` values in generated code for body.
/// ```
/// @PreventNullToAbsent()
/// @POST("/post")
/// Future<String> example(@Field('foo') String? foo);
/// ```
/// Here, if `foo` is `null`, the generated code will not convert it to `absent`.
/// It'll send `null` as the value of `foo`.
///
/// It is useful when you want to send `null` as the value to the server.
/// Such as, when you want to delete a field's value from the database.
@immutable
class PreventNullToAbsent {
  const PreventNullToAbsent();
}
