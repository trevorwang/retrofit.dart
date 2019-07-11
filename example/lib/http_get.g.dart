// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'http_get.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HttpGet _$HttpGetFromJson(Map<String, dynamic> json) {
  return HttpGet(
      headers: (json['headers'] as Map<String, dynamic>)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      origin: json['origin'] as String,
      url: json['url'] as String);
}

Map<String, dynamic> _$HttpGetToJson(HttpGet instance) => <String, dynamic>{
      'headers': instance.headers,
      'origin': instance.origin,
      'url': instance.url
    };
