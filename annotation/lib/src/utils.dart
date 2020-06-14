import 'package:logging/logging.dart';

final logger = Logger("retrofit");

/// colors=red&colors=white&user.name=trevor&user.age=22
String mapToQuery(Map<String, dynamic> map) => _mapToQuery(map).join('&');

Iterable<QueryPair> _mapToQuery(Map<String, dynamic> map, {String prefix}) {
  final querySet = Set<QueryPair>();

  map.forEach((key, value) {
    var name = _urlEncode(key);
    if (prefix != null) {
      name = '$prefix.$name';
    }
    if (value is Iterable) {
      querySet.addAll(_iterableToQuery(name, value));
    } else if (value is Map) {
      querySet.addAll(_mapToQuery(value, prefix: name));
    } else if (value?.toString()?.isNotEmpty == true) {
      querySet.add(QueryPair(name, _urlEncode(value)));
    }
  });
  return querySet;
}

String _urlEncode(dynamic value) => Uri.encodeQueryComponent(value.toString());

Iterable<QueryPair> _iterableToQuery(
  String name,
  Iterable values,
) =>
    values.map((v) => QueryPair(name, _urlEncode(v)));

class QueryPair {
  final String key;
  final String value;
  QueryPair(this.key, this.value);

  @override
  String toString() {
    return '$key=$value';
  }
}
