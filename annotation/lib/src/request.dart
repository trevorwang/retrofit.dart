class Request {
  final String method;
  final String baseUrl;
  final String url;
  final dynamic body;
  final List<PartValue> parts;
  final Map<String, dynamic> parameters;
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
  })  : parameters = parameters ?? const {},
        baseUrl = null,
        parts = parts ?? const [],
        headers = headers ?? const {},
        multipart = multipart ?? false;

  Future toHttpRequest() {
    if (body is Stream<List<int>>) {
      return toStreamedRequest();
    }
    if (multipart) {
      return toMultipartRequest();
    }
    return toBasicRequest();
  }

  Future toBasicRequest() => throw UnimplementedError();
  Future toMultipartRequest() => throw UnimplementedError();
  Future toStreamedRequest() => throw UnimplementedError();

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
      parameters: parameters ?? this.parameters,
      multipart: multipart ?? this.multipart,
    );
  }
}

class PartValue<T> {
  final T value;
  final String name;
  PartValue(this.name, this.value);
}
