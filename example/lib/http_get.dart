import 'package:json_annotation/json_annotation.dart';

part 'http_get.g.dart';

@JsonSerializable()
class HttpGet {
  final Map<String, String> headers;
  final String origin;
  final String url;

  HttpGet({this.headers, this.origin, this.url});

  factory HttpGet.fromJson(Map<String, dynamic> json) =>
      _$HttpGetFromJson(json);
  Map<String, dynamic> toJson() => _$HttpGetToJson(this);
}
