// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'demo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Result _$ResultFromJson(Map<String, dynamic> json) {
  return Result(
    total: json['total'] as String,
    page: json['page'] as int,
    pages: json['pages'] as int,
    tv_shows: (json['tv_shows'] as List)
        ?.map((e) => e == null ? null : Tv.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'total': instance.total,
      'page': instance.page,
      'pages': instance.pages,
      'tv_shows': instance.tv_shows,
    };

Tv _$TvFromJson(Map<String, dynamic> json) {
  return Tv(
    id: json['id'] as int,
    name: json['name'] as String,
    permalink: json['permalink'] as String,
  );
}

Map<String, dynamic> _$TvToJson(Tv instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'permalink': instance.permalink,
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _DemoClient implements DemoClient {
  _DemoClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
  }

  final Dio _dio;

  String baseUrl;

  @override
  getData() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request('/demo',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = Result.fromJson(_result.data);
    return Future.value(value);
  }
}
