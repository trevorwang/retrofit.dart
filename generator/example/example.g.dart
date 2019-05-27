// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _RestClient implements RestClient {
  _RestClient([this._dio]) {
    ArgumentError.checkNotNull(_dio, '_dio');
    _dio.options.baseUrl = 'https://httpbin.org/';
  }

  final Dio _dio;

  @override
  ip(query, {queryies, header}) async {
    ArgumentError.checkNotNull(query, 'query');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{'query1': query};
    queryParameters.addAll(queryies ?? {});
    const _data = null;
    return _dio.request('/get',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: {'Header-One': ' header 1', 'Header-Two': header},
            extra: _extra),
        data: _data);
  }

  @override
  profile(id, {role = "user", map = const {}, map2}) async {
    ArgumentError.checkNotNull(id, 'id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{'role': role};
    queryParameters.addAll(map ?? {});
    final _data = <String, dynamic>{};
    _data.addAll(map2 ?? {});
    return _dio.request('/profile/$id',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: {}, extra: _extra),
        data: _data);
  }

  @override
  createProfile(query, {queryies, header, map2, field, ffff}) async {
    ArgumentError.checkNotNull(query, 'query');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{'query2': query};
    queryParameters.addAll(queryies ?? {});
    final _data = <String, dynamic>{};
    _data.addAll(map2 ?? {});
    return _dio.request('/post',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: {'Accept': 'application/json', 'Header-One': header},
            extra: _extra),
        data: _data);
  }

  @override
  updateProfile2(query, {queryies, header, field, ffff}) async {
    ArgumentError.checkNotNull(query, 'query');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{'query3': query};
    queryParameters.addAll(queryies ?? {});
    final _data = FormData.from({'field': field, 'field-g': ffff});
    return _dio.request('/put',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'PUT', headers: {'Header-One': header}, extra: _extra),
        data: _data);
  }

  @override
  updateProfile(query, {queryies, field, ffff}) async {
    ArgumentError.checkNotNull(query, 'query');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{'query4': query};
    queryParameters.addAll(queryies ?? {});
    final _data = FormData.from({'field': field, 'field-g': ffff});
    return _dio.request('/patch',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'PATCH', headers: {}, extra: _extra),
        data: _data);
  }
}
