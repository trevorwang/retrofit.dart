import 'package:dio/dio.dart' as dio;
import 'package:meta/meta.dart';
import 'utils.dart';

class Request {
  final String method;
  final String baseUrl;
  final String url;
  final dynamic body;
  final List<PartValue> parts;
  final Map<String, dynamic> queryParameters;
  final Map<String, String> headers;
  final bool multipart;

  const Request(
    this.method,
    this.url, {
    this.body,
    baseUrl,
    parts,
    parameters,
    headers,
    multipart,
  })  : queryParameters = parameters ?? const {},
        baseUrl = baseUrl ?? null,
        parts = parts ?? const [],
        headers = headers ?? const {},
        multipart = multipart ?? false;

  Request copyWith({
    String method,
    String baseUrl,
    String url,
    dynamic body,
    List<PartValue> parts,
    Map<String, dynamic> parameters,
    Map<String, String> headers,
    bool multipart,
  }) {
    return Request(
      method ?? this.method,
      url ?? this.url,
      body: body ?? this.body,
      baseUrl: baseUrl ?? this.baseUrl,
      parts: parts ?? this.parts,
      parameters: parameters ?? this.queryParameters,
      multipart: multipart ?? this.multipart,
    );
  }

  dio.RequestOptions toRequest() {
    return dio.RequestOptions(
      method: this.method,
      headers: _buildHeaders(),
    );
  }

  @visibleForTesting
  Uri get basicUri => _buildBasicUri();

  Uri get uri {
    final query = mapToQuery(this.queryParameters);
    if (query.isNotEmpty) {
      // Add query only when there's data
      return basicUri.replace(query: query);
    }
    return basicUri;
  }

  @visibleForTesting
  String get queries => mapToQuery(this.queryParameters);

  Map<String, String> _buildHeaders() => Map.from(this.headers);

  Uri _buildBasicUri() {
    assert(url != null);
    if (url.startsWith('https://') ||
        url.startsWith('http://') ||
        this.baseUrl == null) {
      return Uri.parse(url);
    }
    if (!baseUrl.endsWith('/') && !url.startsWith('/')) {
      return Uri.parse('$baseUrl/$url');
    }
    return Uri.parse('$baseUrl$url');
  }
}

class PartValue<T> {
  final T value;
  final String name;
  PartValue(this.name, this.value);
}
