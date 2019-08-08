// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User();
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{};

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _RestClient implements RestClient {
  _RestClient(this._dio) {
    ArgumentError.checkNotNull(_dio, '_dio');
    _dio.options.baseUrl = 'https://httpbin.org/';
  }

  final Dio _dio;

  @override
  ip(query, {queryies, header}) async {
    ArgumentError.checkNotNull(query, 'query');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{'query1': query};
    queryParameters.addAll(queryies ?? <String, dynamic>{});
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request('/get',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: {'Header-One': ' header 1', 'Header-Two': header},
            extra: _extra),
        data: _data);
    HttpGet value = HttpGet.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  profile(id, {role = "user", map = const <String, dynamic>{}, map2}) async {
    ArgumentError.checkNotNull(id, 'id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{'role': role};
    queryParameters.addAll(map ?? <String, dynamic>{});
    final _data = <String, dynamic>{};
    _data.addAll(map2 ?? <String, dynamic>{});
    final Response<String> _result = await _dio.request('/profile/$id',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: {}, extra: _extra),
        data: _data);
    final value = _result.data;
    return Future.value(value);
  }

  @override
  createProfile(query, {queryies, header, map2, field, ffff}) async {
    ArgumentError.checkNotNull(query, 'query');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{'query2': query};
    queryParameters.addAll(queryies ?? <String, dynamic>{});
    final _data = <String, dynamic>{};
    _data.addAll(map2 ?? <String, dynamic>{});
    final Response<String> _result = await _dio.request('/post',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: {'Accept': 'application/json', 'Header-One': header},
            extra: _extra),
        data: _data);
    final value = _result.data;
    return Future.value(value);
  }

  @override
  updateProfile2(query, {queryies, header, field, ffff}) async {
    ArgumentError.checkNotNull(query, 'query');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{'query3': query};
    queryParameters.addAll(queryies ?? <String, dynamic>{});
    final _data =
        FormData.from(<String, dynamic>{'field': field, 'field-g': ffff});
    final Response<String> _result = await _dio.request('/put',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'PUT', headers: {'Header-One': header}, extra: _extra),
        data: _data);
    final value = _result.data;
    return Future.value(value);
  }

  @override
  updateProfile(query, {queryies, field, ffff}) async {
    ArgumentError.checkNotNull(query, 'query');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{'query4': query};
    queryParameters.addAll(queryies ?? <String, dynamic>{});
    final _data =
        FormData.from(<String, dynamic>{'field': field, 'field-g': ffff});
    final Response<String> _result = await _dio.request('/patch',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'PATCH', headers: {}, extra: _extra),
        data: _data);
    final value = _result.data;
    return Future.value(value);
  }

  @override
  setProfile(image) async {
    ArgumentError.checkNotNull(image, 'image');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData.from(<String, dynamic>{
      'image': UploadFileInfo(image, 'my_profile_image.jpg')
    });
    final Response<String> _result = await _dio.request('/profile',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'POST', headers: {}, extra: _extra),
        data: _data);
    final value = _result.data;
    return Future.value(value);
  }

  @override
  setProfileImage(image) async {
    ArgumentError.checkNotNull(image, 'image');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData.from(<String, dynamic>{
      'image':
          UploadFileInfo(image, image.path.split(Platform.pathSeparator).last)
    });
    final Response<String> _result = await _dio.request('/profile',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'POST', headers: {}, extra: _extra),
        data: _data);
    final value = _result.data;
    return Future.value(value);
  }

  @override
  setProfileImageWithInfo(image) async {
    ArgumentError.checkNotNull(image, 'image');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData.from(<String, dynamic>{'image': image});
    final Response<String> _result = await _dio.request('/profile',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'POST', headers: {}, extra: _extra),
        data: _data);
    final value = _result.data;
    return Future.value(value);
  }

  @override
  createUser(user) async {
    ArgumentError.checkNotNull(user, 'user');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(user.toJson() ?? <String, dynamic>{});
    final Response<String> _result = await _dio.request('/users',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'POST', headers: {}, extra: _extra),
        data: _data);
    final value = _result.data;
    return Future.value(value);
  }

  @override
  groupedUsers() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request('/users',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: {}, extra: _extra),
        data: _data);
    var value = _result.data.map((k, v) =>
        MapEntry(k, (v as List).map((i) => User.fromJson(i)).toList()));

    return Future.value(value);
  }

  @override
  groupedUser() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request('/users',
        queryParameters: queryParameters,
        options: RequestOptions(method: 'GET', headers: {}, extra: _extra),
        data: _data);
    var value = _result.data.map((k, v) => MapEntry(k, User.fromJson(v)));

    return Future.value(value);
  }
}
