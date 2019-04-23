// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'demo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Result _$ResultFromJson(Map<String, dynamic> json) {
  return Result(
      args: json['args'] as Map<String, dynamic>,
      headers: json['headers'] as Map<String, dynamic>,
      origin: json['origin'] as String,
      url: json['url'] as String);
}

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'args': instance.args,
      'headers': instance.headers,
      'origin': instance.origin,
      'url': instance.url
    };
