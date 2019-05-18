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

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _RestClient implements RestClient {
  _RestClient([this._dio]) {
    ArgumentError.checkNotNull(_dio, '_dio');
    final baseUrl = 'https://httpbin.org/';
    if (baseUrl != null && baseUrl.isNotEmpty) {
      _dio.options.baseUrl = baseUrl;
    }
  }

  final Dio _dio;

  Future<Response<String>> ip(String query,
      {Map<String, dynamic> queryies = null, String header = null}) async {
    final queryParameters = <String, dynamic>{'query1': query};
    queryParameters.addAll(queryies ?? {});
    final data = <String, dynamic>{};
    return _dio.request<String>('/get',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: {'Header-One': ' header 1', 'Header-Two': header}),
        data: data);
  }

  Future<Response<String>> profile(String id,
      {String role = "user",
      Map<String, dynamic> map = const {},
      Map<String, dynamic> map2 = null}) async {
    final queryParameters = <String, dynamic>{'role': role};
    queryParameters.addAll(map ?? {});
    final data = <String, dynamic>{};
    data.addAll(map2 ?? {});
    return _dio.request<String>('/profile/$id',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: {}),
        data: data);
  }

  Future<Response<String>> createProfile(String query,
      {Map<String, dynamic> queryies = null,
      String header = null,
      Map<String, dynamic> map2 = null,
      int field = null,
      String ffff = null}) async {
    final queryParameters = <String, dynamic>{'query2': query};
    queryParameters.addAll(queryies ?? {});
    final data = <String, dynamic>{};
    data.addAll(map2 ?? {});
    data.addAll({'field': field, 'field-g': ffff});
    return _dio.request<String>('/post',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: {'Accept': 'application/json', 'Header-One': header}),
        data: data);
  }

  Future<Response<String>> updateProfile2(String query,
      {Map<String, dynamic> queryies = null,
      String header = null,
      int field = null,
      String ffff = null}) async {
    final queryParameters = <String, dynamic>{'query3': query};
    queryParameters.addAll(queryies ?? {});
    final data = <String, dynamic>{};
    data.addAll({'field': field, 'field-g': ffff});
    return _dio.request<String>('/put',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'PUT', headers: {'Header-One': header}),
        data: data);
  }

  Future<Response<String>> updateProfile(String query,
      {Map<String, dynamic> queryies = null,
      int field = null,
      String ffff = null}) async {
    final queryParameters = <String, dynamic>{'query4': query};
    queryParameters.addAll(queryies ?? {});
    final data = <String, dynamic>{};
    data.addAll({'field': field, 'field-g': ffff});
    return _dio.request<String>('/patch',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'PATCH', headers: {}),
        data: data);
  }
}
