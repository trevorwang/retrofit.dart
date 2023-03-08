import 'package:json_annotation/json_annotation.dart';

part 'api_result.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResult<T> {
  const ApiResult({
    required this.code,
    required this.data,
    this.msg,
  });

  factory ApiResult.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$ApiResultFromJson(json, fromJsonT);

  ///接口调用成功的code码
  static const success = 0;
  static const unknown = -1;
  final int code;
  final T data;
  final String? msg;

  ///业务接口执行成功
  bool get isSuccess => code == success;

  Map<String, dynamic> toJson(Object? Function(T) toJsonT) =>
      _$ApiResultToJson(this, toJsonT);

  @override
  String toString() => 'ApiResult{code: $code, data: $data, msg: $msg}';
}
