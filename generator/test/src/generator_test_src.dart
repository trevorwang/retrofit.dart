import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import 'package:source_gen_test/annotations.dart';

@ShouldGenerate(
  '''
// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _RestClient implements RestClient {
  _RestClient(
    this._dio, {
    this.baseUrl,
  });

  final Dio _dio;

  String? baseUrl;
''',
  contains: true,
)
@RestApi()
abstract class RestClient {}

@ShouldGenerate(
  '''
class _BaseUrl implements BaseUrl {
  _BaseUrl(
    this._dio, {
    this.baseUrl,
  }) {
    baseUrl ??= 'http://httpbin.org/';
  }

  final Dio _dio;

  String? baseUrl;
''',
  contains: true,
)
@RestApi(baseUrl: 'http://httpbin.org/')
abstract class BaseUrl {}

@ShouldGenerate(
  '''
    const _extra = <String, dynamic>{};
''',
  contains: true,
)
@RestApi()
abstract class EmptyExtras {
  @GET('/list/')
  @Extra({})
  Future<void> list();
}

@ShouldGenerate(
  '''
    const _extra = <String, dynamic>{'key': 'value'};
  ''',
  contains: true,
)
@RestApi()
abstract class ExtrasWithPrimitiveValues {
  @GET('/list/')
  @Extra({'key': 'value'})
  Future<void> list();
}

@ShouldGenerate(
  '''
    const _extra = <String, dynamic>{
      'key': 'value',
      'key2': 'value2',
    };
  ''',
  contains: true,
)
@RestApi()
abstract class MultipleExtrasWithPrimitiveValues {
  @GET('/list/')
  @Extra({'key': 'value'})
  @Extra({'key2': 'value2'})
  Future<void> list();
}

@ShouldGenerate(
  '''
    const _extra = <String, dynamic>{'key': CustomConstant()};
''',
  contains: true,
)
@RestApi()
abstract class ExtrasWithCustomConstant {
  @GET('/list/')
  @Extra({'key': CustomConstant()})
  Future<void> list();
}

class CustomConstant {
  const CustomConstant();
}

@ShouldGenerate(
  '''
    final _headers = <String, dynamic>{};
''',
  contains: true,
)
@RestApi()
abstract class EmptyHeaders {
  @GET('/list/')
  @Headers(<String, dynamic>{})
  Future<void> list();
}

@ShouldGenerate(
  '''
    final _headers = <String, dynamic>{r'key': 'value'};
''',
  contains: true,
)
@RestApi()
abstract class HeadersWithPrimitiveValues {
  @GET('/list/')
  @Headers(<String, dynamic>{'key': 'value'})
  Future<void> list();
}

@ShouldGenerate(
  '''
    final _headers = <String, dynamic>{
      r'key': 'value',
      r'key2': 'value2',
    };
  ''',
  contains: true,
)
@RestApi()
abstract class MultipleHeadersWithPrimitiveValues {
  @GET('/list/')
  @Headers(<String, dynamic>{'key': 'value'})
  @Headers(<String, dynamic>{'key2': 'value2'})
  Future<void> list();
}

@ShouldGenerate(
  '''
Options(
      method: 'GET',
  ''',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class HttpGetTest {
  @GET('/get')
  Future<String> ip();
}

@ShouldGenerate(
  '''
Options(
      method: 'POST',
  ''',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class HttpPostTest {
  @POST('/post')
  Future<String> ip();
}

@ShouldGenerate(
  '''
Options(
      method: 'PUT',
  ''',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class HttpPutTest {
  @PUT('/put')
  Future<String> ip();
}

@ShouldGenerate(
  '''
Options(
      method: 'DELETE',''',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class HttpDeleteTest {
  @DELETE('/delete')
  Future<String> ip();
}

@ShouldGenerate(
  '''
Options(
      method: 'PATCH',
''',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class HttpPatchTest {
  @PATCH('/delete')
  Future<String> ip();
}

@ShouldGenerate(
  "contentType: 'application/x-www-form-urlencoded'",
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class FormUrlEncodedTest {
  @POST('/get')
  @FormUrlEncoded()
  Future<String> ip();
}

@ShouldGenerate(
  "contentType: 'multipart/form-data'",
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class MultipartTest {
  @POST('/get')
  @MultiPart()
  Future<String> ip();
}

@ShouldThrow('Two content-type annotation on one request ip', element: false)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TwoContentTypeAnnotationOnSameMethodTest {
  @POST('/get')
  @MultiPart()
  @FormUrlEncoded()
  Future<String> ip();
}

@ShouldGenerate(
  r'/image/${imageType.name}/${id}_XL.png',
  contains: true,
)
@RestApi()
abstract class PathTest {
  @GET('/image/{imageType}/{id}_XL.png')
  Future<HttpResponse<dynamic>> getImage(
    @Path('imageType') ImageType imageType,
    @Path('id') String id,
  );
}

enum ImageType { icon, large }

@ShouldGenerate(
  '''
    final _data = FormData();
    _data.files.add(MapEntry(
      'image',
      MultipartFile.fromFileSync(
        image.path,
        filename: image.path.split(Platform.pathSeparator).last,
      ),
    ));
''',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class FilePartTest {
  @POST('/profile')
  Future<String> setProfile(@Part() File image);
}

@ShouldGenerate(
  '''
    final _data = FormData();
    _data.files.add(MapEntry(
      'image',
      MultipartFile.fromFileSync(
        image.path,
        filename: 'my_profile_image.jpg',
      ),
    ));
''',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class FilePartWithCustomNameTest {
  @POST('/profile')
  Future<String> setProfile(
    @Part(name: 'image', fileName: 'my_profile_image.jpg') File image,
  );
}

@ShouldGenerate(
  '''
    final _data = FormData();
    _data.files.addAll(images.map((i) => MapEntry('images', i)));
''',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class FilePartWithMultipartListTest {
  @POST('/profile')
  Future<String> setProfile(@Part() List<MultipartFile> images);
}

@ShouldGenerate(
  '''
    final _data = FormData();
    if (images != null) {
      _data.files.addAll(images.map((i) => MapEntry('images', i)));
    }
''',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class FilePartWithNullableMultipartListTest {
  @POST('/profile')
  Future<String> setProfile(@Part() List<MultipartFile>? images);
}

@ShouldGenerate(
  '''
    final _data = FormData();
    _data.files.add(MapEntry(
      'image',
      MultipartFile.fromFileSync(
        image.path,
        filename: image.path.split(Platform.pathSeparator).last,
      ),
    ));
  ''',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class UploadFileInfoPartTest {
  @POST('/profile')
  Future<String> setProfile(@Part() File image);
}

@ShouldGenerate(
  '''
    final value = User.fromJson(_result.data!);
    return value;
''',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class GenericCast {
  @POST('/users/1')
  Future<User> getUser();
}

@ShouldGenerate(
  '''
    final value = _result.data == null ? null : User.fromJson(_result.data!);
    return value;
''',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class NullableGenericCast {
  @POST('/users/1')
  Future<User?> getUser();
}

@ShouldGenerate(
  '''
    yield value;
''',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class StreamReturnType {
  @POST('/users/1')
  Stream<User> getUser();
}

enum TestEnum { A, B }

@ShouldGenerate(
  '''
    final value = TestEnum.values.firstWhere(
      (e) => e.name == _result.data,
      orElse: () => throw ArgumentError(
        'TestEnum does not contain value \${_result.data}',
      ),
    );
    return value;
''',
  contains: true,
)
@RestApi()
abstract class EnumReturnType {
  @GET('/')
  Future<TestEnum> getTestEnum();
}

enum EnumParam {
  enabled,
  disabled,
}

@ShouldGenerate(
  '''
    final queryParameters = <String, dynamic>{r'test': status?.name};
''',
  contains: true,
)
@RestApi()
abstract class TestQueryParamEnum {
  @GET('/test')
  Future<void> getTest(@Query('test') EnumParam? status);
}

enum FromJsonEnum {
  a,
  b,
  ;

  factory FromJsonEnum.fromJson(Map<String, dynamic> json) => FromJsonEnum.a;
}

@ShouldGenerate(
  '''
    final value = FromJsonEnum.fromJson(_result.data!);
    return value;
''',
  contains: true,
)
@RestApi()
abstract class EnumFromJsonReturnType {
  @GET('/')
  Future<FromJsonEnum> getTestEnum();
}

enum ToJsonEnum {
  plus(1),
  minus(-1),
  ;

  const ToJsonEnum(this.value);

  final int value;

  int toJson() => value;
}

@ShouldGenerate(
  '''
    final queryParameters = <String, dynamic>{r'test': status?.toJson()};
''',
  contains: true,
)
@RestApi()
abstract class TestQueryParamEnumToJson {
  @GET('/test')
  Future<void> getTest(@Query('test') ToJsonEnum? status);
}

@ShouldGenerate(
  '''
  Stream<User> getUser() async* {
''',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class StreamReturnModifier {
  @POST('/users/1')
  Stream<User> getUser();
}

class User implements AbstractUser {
  User();

  factory User.fromJson(Map<String, dynamic> json) => User();

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{};
}

@JsonSerializable(genericArgumentFactories: true)
class GenericUser<T> implements AbstractUser {
  GenericUser();

  factory GenericUser.fromJson() => GenericUser<T>();

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{};
}

@JsonSerializable(genericArgumentFactories: false)
class GenericUserWithoutGenericArgumentFactories<T> implements AbstractUser {
  GenericUserWithoutGenericArgumentFactories();

  factory GenericUserWithoutGenericArgumentFactories.fromJson() =>
      GenericUserWithoutGenericArgumentFactories<T>();

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{};
}

class JsonSerializable {
  const JsonSerializable({required this.genericArgumentFactories});

  final bool genericArgumentFactories;
}

mixin AbstractUserMixin {
  Map<String, dynamic> toJson();
}

abstract class AbstractUser with AbstractUserMixin {
  factory AbstractUser() = User;

  factory AbstractUser.fromJson(Map<String, dynamic> json) =>
      User.fromJson(json);
}

Map<String, dynamic> serializeUser(User object) => object.toJson();

@ShouldGenerate(
  '''
    final value = _result.data!;
    return value;
''',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class GenericCastBasicType {
  @POST('/users/1')
  Future<String> getUser();
}

@ShouldGenerate(
  '''
    final value = _result.data;
    return value;
''',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class NullableGenericCastBasicType {
  @POST('/users/1')
  Future<String?> getUser();
}

@ShouldGenerate(
  '''
    final _data = <String, dynamic>{};
    _data.addAll(user.toJson());
''',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TestObjectBody {
  @POST('/users')
  Future<String> createUser(@Body() User user);
}

@ShouldGenerate(
  '''
    final _data = <String, dynamic>{};
    _data.addAll(user?.toJson() ?? <String, dynamic>{});
''',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TestObjectBodyNullable {
  @POST('/users')
  Future<String> createUser({@Body() User? user});
}

@ShouldGenerate(
  '''
    final _data = <String, dynamic>{};
    _data.addAll(user.toJson());
''',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TestAbstractObjectBody {
  @POST('/users')
  Future<String> createUser(@Body() AbstractUser user);
}

@ShouldGenerate(
  '''
    final _data = <String, dynamic>{};
    _data.addAll(user?.toJson() ?? <String, dynamic>{});
''',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TestAbstractObjectBodyNullable {
  @POST('/users')
  Future<String> createUser({@Body() AbstractUser? user});
}

@ShouldGenerate(
  '''
    final queryParameters = <String, dynamic>{r'u': u.toJson()};
    queryParameters.addAll(user1.toJson());
    queryParameters.addAll(user2.toJson());
''',
  contains: true,
)
@ShouldGenerate(
  '''
    final queryParameters = <String, dynamic>{r'u': u.toJson()};
    queryParameters.addAll(user3?.toJson() ?? <String, dynamic>{});
    queryParameters.addAll(user4?.toJson() ?? <String, dynamic>{});
''',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TestObjectQueries {
  @POST('/users')
  Future<String> createUser(
    @Query('u') User u,
    @Queries() User user1,
    @Queries() User user2,
  );

  @POST('/users')
  Future<String> createNullableUser(
    @Query('u') User u, {
    @Queries() User? user3,
    @Queries() User? user4,
  });
}

class CustomObject {
  CustomObject(this.id);

  final String id;
}

@ShouldGenerate(
  '''
    final queryParameters = <String, dynamic>{r'test': date?.toIso8601String()};
''',
  contains: true,
)
@RestApi()
abstract class TestQueryParamDateTime {
  @GET('/test')
  Future<void> getTest(@Query('test') DateTime? date);
}

@ShouldGenerate(
  '''
    final _data = customObject;
''',
  contains: true,
  expectedLogItems: [
    "CustomObject must provide a `toJson()` method which return a Map.\nIt is programmer's responsibility to make sure the CustomObject is properly serialized",
  ],
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TestCustomObjectBody {
  @POST('/custom-object')
  Future<String> createCustomObject(@Body() CustomObject customObject);
}

@ShouldGenerate(
  '''
    var value = _result.data!.map((k, dynamic v) => MapEntry(
        k,
        (v as List)
            .map((i) => User.fromJson(i as Map<String, dynamic>))
            .toList()));
    return value;
''',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TestMapBody {
  @GET('/xx')
  Future<Map<String, List<User>>> getResult();
}

@ShouldGenerate(
  '''
    var value = _result.data?.map((k, dynamic v) => MapEntry(
        k,
        (v as List)
            .map((i) => User.fromJson(i as Map<String, dynamic>))
            .toList()));
    return value;
''',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class NullableTestMapBody {
  @GET('/xx')
  Future<Map<String, List<User>>?> getResult();
}

@ShouldGenerate(
  '''
    var value = _result.data!.map((k, dynamic v) =>
        MapEntry(k, User.fromJson(v as Map<String, dynamic>)));
    return value;
''',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TestMapBody2 {
  @GET('/xx')
  Future<Map<String, User>> getResult();
}

@ShouldGenerate(
  '''
    var value = _result.data?.map((k, dynamic v) =>
        MapEntry(k, User.fromJson(v as Map<String, dynamic>)));
    return value;
''',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class NullableTestMapBody2 {
  @GET('/xx')
  Future<Map<String, User>?> getResult();
}

@ShouldGenerate(
  '''
    final value = _result.data!.cast<String>();
    return value;
''',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TestBasicListString {
  @GET('/xx')
  Future<List<String>> getResult();
}

@ShouldGenerate(
  '''
    final value = _result.data?.cast<String>();
    return value;
''',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class NullableTestBasicListString {
  @GET('/xx')
  Future<List<String>?> getResult();
}

@ShouldGenerate(
  '''
    final value = _result.data!.cast<bool>();
    return value;
''',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TestBasicListBool {
  @GET('/xx')
  Future<List<bool>> getResult();
}

@ShouldGenerate(
  '''
    final value = _result.data?.cast<bool>();
    return value;
''',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class NullableTestBasicListBool {
  @GET('/xx')
  Future<List<bool>?> getResult();
}

@ShouldGenerate(
  '''
    final value = _result.data!.cast<int>();
    return value;
''',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TestBasicListInt {
  @GET('/xx')
  Future<List<int>> getResult();
}

@ShouldGenerate(
  '''
    final value = _result.data?.cast<int>();
    return value;
''',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class NullableTestBasicListInt {
  @GET('/xx')
  Future<List<int>?> getResult();
}

@ShouldGenerate(
  '''
    final value = _result.data!.cast<double>();
    return value;
''',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TestBasicListDouble {
  @GET('/xx')
  Future<List<double>> getResult();
}

@ShouldGenerate(
  '''
    final value = _result.data?.cast<double>();
    return value;
''',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class NullableTestBasicListDouble {
  @GET('/xx')
  Future<List<double>?> getResult();
}

@ShouldGenerate(
  'cancelToken: cancelToken',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TestCancelToken {
  @POST('/users')
  Future<String> createUser(
    @Body() User user,
    @CancelRequest() CancelToken cancelToken,
  );
}

@ShouldGenerate(
  'onSendProgress: onSendProgress',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TestSendProgress {
  @POST('/users')
  Future<String> createUser(
    @Body() User user,
    @SendProgress() ProgressCallback onSendProgress,
  );
}

@ShouldGenerate(
  'onReceiveProgress: onReceiveProgress',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TestReceiveProgress {
  @POST('/users')
  Future<String> createUser(
    @Body() User user,
    @ReceiveProgress() ProgressCallback onReceiveProgress,
  );
}

@ShouldGenerate(
  '''
Options(
      method: 'HEAD',''',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TestHeadMethod {
  @HEAD('/')
  Future<String> testHeadMethod();
}

@ShouldGenerate(
  '''
Options(
      method: 'OPTIONS',''',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TestOptionsMethod {
  @OPTIONS('/')
  Future<String> testOptionsMethod();
}

@ShouldGenerate(
  '''
    final httpResponse = HttpResponse(null, _result);
''',
  contains: true,
)
@RestApi()
abstract class TestHttpResponseVoid {
  @GET('/')
  Future<HttpResponse<void>> noResponseData();
}

@ShouldGenerate(
  '''
    final httpResponse = HttpResponse(value, _result);
''',
  contains: true,
)
@RestApi()
abstract class TestHttpResponseObject {
  @GET('/')
  Future<HttpResponse<Map<String, dynamic>>> responseWithObject();
}

@ShouldGenerate(
  '''
    final httpResponse = HttpResponse(value, _result);
''',
  contains: true,
)
@RestApi()
abstract class TestHttpResponseArray {
  @GET('/')
  Future<HttpResponse<List<String>>> responseWithArray();
}

@ShouldGenerate(
  '''
    final _data = FormData();
    _data.files.addAll(files.map((i) => MapEntry(
        'files',
        MultipartFile.fromFileSync(
          i.path,
          filename: i.path.split(Platform.pathSeparator).last,
        ))));
''',
  contains: true,
)
@ShouldGenerate(
  '''
    final _data = FormData();
    if (files != null) {
      _data.files.addAll(files.map((i) => MapEntry(
          'files',
          MultipartFile.fromFileSync(
            i.path,
            filename: i.path.split(Platform.pathSeparator).last,
          ))));
    }
''',
  contains: true,
)
@ShouldGenerate(
  '''
    if (file != null) {
      _data.files.add(MapEntry(
        'file',
        MultipartFile.fromFileSync(
          file.path,
          filename: file.path.split(Platform.pathSeparator).last,
        ),
      ));
    }
''',
  contains: true,
)
@RestApi()
abstract class TestFileList {
  @POST('/')
  Future<void> testFileList(@Part() List<File> files);

  @POST('/')
  Future<void> testOptionalFileList(@Part() List<File>? files);

  @POST('/')
  Future<void> testOptionalFile({@Part() File file});
}

@ShouldGenerate(
  '''
    final _data = FormData();
    _data.fields.add(MapEntry(
      'users',
      jsonEncode(users),
    ));
    ''',
  contains: true,
)
@ShouldGenerate(
  '''
    final _data = FormData();
    _data.fields.add(MapEntry(
      'item',
      jsonEncode(user),
    ));
    ''',
  contains: true,
)
@ShouldGenerate(
  '''
    mapList.forEach((i) {
      _data.fields.add(MapEntry('mapList', jsonEncode(i)));
    });
    ''',
  contains: true,
)
@ShouldGenerate(
  '''
    final _data = FormData.fromMap(map);
    ''',
  contains: true,
)
@ShouldGenerate(
  '''
    _data.fields.add(MapEntry(
      'a',
      a.toString(),
    ));
    _data.fields.add(MapEntry(
      'b',
      b.toString(),
    ));
    _data.fields.add(MapEntry(
      'c',
      c.toString(),
    ));
    if (d != null) {
      _data.fields.add(MapEntry(
        'd',
        d,
      ));
    }
    ''',
  contains: true,
)
@RestApi()
abstract class TestModelList {
  @POST('/')
  Future<void> testUserList(@Part() List<User> users);

  @POST('/')
  Future<void> testUser(@Part(name: 'item') User user);

  @POST('/')
  Future<void> testListMap(@Part() List<Map<String, dynamic>> mapList);

  @POST('/')
  Future<void> testMap(@Part() Map<String, dynamic> map);

  @POST('/')
  Future<void> testBasicType(
    @Part() int a,
    @Part() bool b,
    @Part() double c, {
    @Part() String? d,
  });
}

@ShouldGenerate(
  '''
  RequestOptions newRequestOptions(Object? options) {
    if (options is RequestOptions) {
      return options as RequestOptions;
    }
    if (options is Options) {
      return RequestOptions(
        method: options.method,
        sendTimeout: options.sendTimeout,
        receiveTimeout: options.receiveTimeout,
        extra: options.extra,
        headers: options.headers,
        responseType: options.responseType,
        contentType: options.contentType.toString(),
        validateStatus: options.validateStatus,
        receiveDataWhenStatusError: options.receiveDataWhenStatusError,
        followRedirects: options.followRedirects,
        maxRedirects: options.maxRedirects,
        requestEncoder: options.requestEncoder,
        responseDecoder: options.responseDecoder,
        path: '',
      );
    }
    return RequestOptions(path: '');
  }
''',
  contains: true,
)
@ShouldGenerate(
  '''
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    await _dio.fetch<void>(newOptions.copyWith(
      method: 'GET',
      baseUrl: baseUrl ?? _dio.options.baseUrl,
      queryParameters: queryParameters,
      path: '',
    )..data = _data);
  ''',
  contains: true,
)
@RestApi()
abstract class CustomOptions {
  @GET('')
  Future<void> testOptions(@DioOptions() Options options);
}

@ShouldGenerate(
  '''
    final value = JsonMapper.fromMap<User>(_result.data!)!;
    return value;
''',
  contains: true,
)
@RestApi(
  baseUrl: 'https://httpbin.org/',
  parser: Parser.DartJsonMapper,
)
abstract class JsonMapperGenericCast {
  @POST('/xx')
  Future<User> getUser();
}

@ShouldGenerate(
  '''
    final value =
        _result.data == null ? null : JsonMapper.fromMap<User>(_result.data!)!;
    return value;
''',
  contains: true,
)
@RestApi(
  baseUrl: 'https://httpbin.org/',
  parser: Parser.DartJsonMapper,
)
abstract class NullableJsonMapperGenericCast {
  @POST('/xx')
  Future<User?> getUser();
}

@ShouldGenerate(
  '''
    var value = _result.data!
        .map(
            (dynamic i) => JsonMapper.fromMap<User>(i as Map<String, dynamic>)!)
        .toList();
    return value;
''',
  contains: true,
)
@RestApi(
  baseUrl: 'https://httpbin.org/',
  parser: Parser.DartJsonMapper,
)
abstract class JsonMapperTestListBody {
  @GET('/xx')
  Future<List<User>> getResult();
}

@ShouldGenerate(
  '''
    var value = _result.data!.map((k, dynamic v) => MapEntry(
        k,
        (v as List)
            .map((i) => JsonMapper.fromMap<User>(i as Map<String, dynamic>)!)
            .toList()));
    return value;
''',
  contains: true,
)
@RestApi(
  baseUrl: 'https://httpbin.org/',
  parser: Parser.DartJsonMapper,
)
abstract class JsonMapperTestMapBody {
  @GET('/xx')
  Future<Map<String, List<User>>> getResult();
}

@ShouldGenerate(
  '''
    var value = _result.data!.map((k, dynamic v) =>
        MapEntry(k, JsonMapper.fromMap<User>(v as Map<String, dynamic>)!));
    return value;
''',
  contains: true,
)
@RestApi(
  baseUrl: 'https://httpbin.org/',
  parser: Parser.DartJsonMapper,
)
abstract class JsonMapperTestMapBody2 {
  @GET('/xx')
  Future<Map<String, User>> getResult();
}

@ShouldGenerate(
  '''
    final value = User.fromMap(_result.data!);
    return value;
''',
  contains: true,
)
@RestApi(
  baseUrl: 'https://httpbin.org/',
  parser: Parser.MapSerializable,
)
abstract class MapSerializableGenericCast {
  @POST('/xx')
  Future<User> getUser();
}

@ShouldGenerate(
  '''
    final value = _result.data == null ? null : User.fromMap(_result.data!);
    return value;
''',
  contains: true,
)
@RestApi(
  baseUrl: 'https://httpbin.org/',
  parser: Parser.MapSerializable,
)
abstract class NullableMapSerializableGenericCast {
  @POST('/xx')
  Future<User?> getUser();
}

@ShouldGenerate(
  '''
    var value = _result.data!
        .map((dynamic i) => User.fromMap(i as Map<String, dynamic>))
        .toList();
    return value;
''',
  contains: true,
)
@RestApi(
  baseUrl: 'https://httpbin.org/',
  parser: Parser.MapSerializable,
)
abstract class MapSerializableTestListBody {
  @GET('/xx')
  Future<List<User>> getResult();
}

@ShouldGenerate(
  '''
    var value = _result.data
        ?.map((dynamic i) => User.fromMap(i as Map<String, dynamic>))
        .toList();
    return value;
''',
  contains: true,
)
@RestApi(
  baseUrl: 'https://httpbin.org/',
  parser: Parser.MapSerializable,
)
abstract class NullableMapSerializableTestListBody {
  @GET('/xx')
  Future<List<User>?> getResult();
}

@ShouldGenerate(
  '''
    var value = _result.data!.map((k, dynamic v) => MapEntry(
        k,
        (v as List)
            .map((i) => User.fromMap(i as Map<String, dynamic>))
            .toList()));
    return value;
''',
  contains: true,
)
@RestApi(
  baseUrl: 'https://httpbin.org/',
  parser: Parser.MapSerializable,
)
abstract class MapSerializableTestMapBody {
  @GET('/xx')
  Future<Map<String, List<User>>> getResult();
}

@ShouldGenerate(
  '''
    var value = _result.data?.map((k, dynamic v) => MapEntry(
        k,
        (v as List)
            .map((i) => User.fromMap(i as Map<String, dynamic>))
            .toList()));
    return value;
''',
  contains: true,
)
@RestApi(
  baseUrl: 'https://httpbin.org/',
  parser: Parser.MapSerializable,
)
abstract class NullableMapSerializableTestMapBody {
  @GET('/xx')
  Future<Map<String, List<User>>?> getResult();
}

@ShouldGenerate(
  '''
    var value = _result.data!.map(
        (k, dynamic v) => MapEntry(k, User.fromMap(v as Map<String, dynamic>)));
    return value;
''',
  contains: true,
)
@RestApi(
  baseUrl: 'https://httpbin.org/',
  parser: Parser.MapSerializable,
)
abstract class MapSerializableTestMapBody2 {
  @GET('/xx')
  Future<Map<String, User>> getResult();
}

@ShouldGenerate(
  '''
    var value = _result.data?.map(
        (k, dynamic v) => MapEntry(k, User.fromMap(v as Map<String, dynamic>)));
    return value;
''',
  contains: true,
)
@RestApi(
  baseUrl: 'https://httpbin.org/',
  parser: Parser.MapSerializable,
)
abstract class NullableMapSerializableTestMapBody2 {
  @GET('/xx')
  Future<Map<String, User>?> getResult();
}

@ShouldGenerate(
  '''
    final value = await compute(deserializeUser, _result.data!);
    return value;
''',
  contains: true,
)
@RestApi(
  baseUrl: 'https://httpbin.org/',
  parser: Parser.FlutterCompute,
)
abstract class ComputeGenericCast {
  @POST('/xx')
  Future<User> getUser();
}

@ShouldGenerate(
  '''
    final value = _result.data == null
        ? null
        : await compute(deserializeUser, _result.data!);
    return value;
''',
  contains: true,
)
@RestApi(
  baseUrl: 'https://httpbin.org/',
  parser: Parser.FlutterCompute,
)
abstract class NullableComputeGenericCast {
  @POST('/xx')
  Future<User?> getUser();
}

@ShouldGenerate(
  '''
    var value = await compute(
      deserializeUserList,
      _result.data!.cast<Map<String, dynamic>>(),
    );
    return value;
''',
  contains: true,
)
@RestApi(
  baseUrl: 'https://httpbin.org/',
  parser: Parser.FlutterCompute,
)
abstract class ComputeTestListBody {
  @GET('/xx')
  Future<List<User>> getResult();
}

@ShouldGenerate(
  '''
    var value = _result.data == null
        ? null
        : await compute(
            deserializeUserList,
            _result.data!.cast<Map<String, dynamic>>(),
          );
    return value;
  ''',
  contains: true,
)
@RestApi(
  baseUrl: 'https://httpbin.org/',
  parser: Parser.FlutterCompute,
)
abstract class NullableComputeTestListBody {
  @GET('/xx')
  Future<List<User>?> getResult();
}

@ShouldGenerate(
  '''
    var value = Map.fromEntries(await Future.wait(_result.data!.entries.map(
        (e) async => MapEntry(
            e.key,
            await compute(deserializeUserList,
                (e.value as List).cast<Map<String, dynamic>>())))));
    return value;
''',
  contains: true,
  expectedLogItems: [
    '''
Return types should not be a map when running `Parser.FlutterCompute`, as spawning an isolate per entry is extremely intensive.
You should create a new class to encapsulate the response.
'''
  ],
)
@RestApi(
  baseUrl: 'https://httpbin.org/',
  parser: Parser.FlutterCompute,
)
abstract class ComputeTestMapBody {
  @GET('/xx')
  Future<Map<String, List<User>>> getResult();
}

@ShouldGenerate(
  '''
    var value = Map.fromEntries(await Future.wait(_result.data!.entries.map(
        (e) async => MapEntry(
            e.key,
            await compute(deserializeUserList,
                (e.value as List).cast<Map<String, dynamic>>())))));
    return value;
''',
  contains: true,
  expectedLogItems: [
    '''
Return types should not be a map when running `Parser.FlutterCompute`, as spawning an isolate per entry is extremely intensive.
You should create a new class to encapsulate the response.
'''
  ],
)
@RestApi(
  baseUrl: 'https://httpbin.org/',
  parser: Parser.FlutterCompute,
)
abstract class NullableComputeTestMapBody {
  @GET('/xx')
  Future<Map<String, List<User>>?> getResult();
}

@ShouldGenerate(
  '''
    var value = Map.fromEntries(await Future.wait(_result.data!.entries.map(
        (e) async => MapEntry(e.key,
            await compute(deserializeUser, e.value as Map<String, dynamic>)))));
    return value;
''',
  contains: true,
  expectedLogItems: [
    '''
Return types should not be a map when running `Parser.FlutterCompute`, as spawning an isolate per entry is extremely intensive.
You should create a new class to encapsulate the response.
'''
  ],
)
@RestApi(
  baseUrl: 'https://httpbin.org/',
  parser: Parser.FlutterCompute,
)
abstract class ComputeTestMapBody2 {
  @GET('/xx')
  Future<Map<String, User>> getResult();
}

@ShouldGenerate(
  '''
    var value = _result.data == null
        ? null
        : Map.fromEntries(await Future.wait(_result.data!.entries.map(
            (e) async => MapEntry(
                e.key,
                await compute(
                    deserializeUser, e.value as Map<String, dynamic>)))));
    return value;
''',
  contains: true,
  expectedLogItems: [
    '''
Return types should not be a map when running `Parser.FlutterCompute`, as spawning an isolate per entry is extremely intensive.
You should create a new class to encapsulate the response.
'''
  ],
)
@RestApi(
  baseUrl: 'https://httpbin.org/',
  parser: Parser.FlutterCompute,
)
abstract class NullableComputeTestMapBody2 {
  @GET('/xx')
  Future<Map<String, User>?> getResult();
}

@ShouldGenerate(
  '''
    final queryParameters = <String, dynamic>{
      r'u': await compute(serializeUser, user)
    };
''',
  contains: true,
)
@RestApi(
  baseUrl: 'https://httpbin.org/',
  parser: Parser.FlutterCompute,
)
abstract class ComputeQuery {
  @GET('/xx')
  Future<void> getResult(@Query('u') User user);
}

@ShouldGenerate(
  '''
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(await compute(serializeUser, user));
''',
  contains: true,
)
@RestApi(
  baseUrl: 'https://httpbin.org/',
  parser: Parser.FlutterCompute,
)
abstract class ComputeQueries {
  @GET('/xx')
  Future<void> getResult(@Queries() User user);
}

@ShouldGenerate(
  '''
    final _data = <String, dynamic>{};
    _data.addAll(await compute(serializeUser, user));
''',
  contains: true,
)
@RestApi(
  baseUrl: 'https://httpbin.org/',
  parser: Parser.FlutterCompute,
)
abstract class TestComputeObjectBody {
  @GET('/xx')
  Future<void> getResult(@Body() User user);
}

@ShouldGenerate(
  '''
    final _data = await compute(serializeUserList, users);
''',
  contains: true,
)
@RestApi(
  baseUrl: 'https://httpbin.org/',
  parser: Parser.FlutterCompute,
)
abstract class TestComputeObjectListBody {
  @GET('/xx')
  Future<void> getResult(@Body() List<User> users);
}

@ShouldGenerate(
  '''
    final _data = <String, dynamic>{};
    _data.addAll(user == null
        ? <String, dynamic>{}
        : await compute(serializeUser, user));
''',
  contains: true,
)
@RestApi(
  baseUrl: 'https://httpbin.org/',
  parser: Parser.FlutterCompute,
)
abstract class TestComputeNullableObjectBody {
  @GET('/xx')
  Future<void> getResult(@Body() User? user);
}

@ShouldGenerate(
  '_data.removeWhere((k, v) => v == null);',
  contains: true,
)
@RestApi()
abstract class MapBodyShouldBeCleanTest {
  @PUT('/')
  Future<void> update(@Body(nullToAbsent: true) Map<String, dynamic> data);
}

@ShouldGenerate(
  '_data.removeWhere((k, v) => v == null);',
  contains: true,
)
@RestApi()
abstract class JsonSerializableBodyShouldBeCleanTest {
  @PUT('/')
  Future<void> update(@Body(nullToAbsent: true) User obj);
}

@ShouldGenerate(
  '''
    final _data = str;
    await _dio.fetch<void>(_setStreamType<void>(Options(''',
  contains: true,
  expectedLogItems: [
    "String must provide a `toJson()` method which return a Map.\nIt is programmer's responsibility to make sure the String is properly serialized"
  ],
)
@RestApi()
abstract class NonJsonSerializableBodyShouldNotBeCleanTest {
  @PUT('/')
  Future<void> update(@Body() String str);
}

@ShouldGenerate(
  '''
    final _data = users.map((e) => e.toJson()).toList();
    await _dio.fetch<void>(_setStreamType<void>(Options(
  ''',
  contains: true,
)
@RestApi()
abstract class ListBodyShouldNotBeCleanTest {
  @PUT('/')
  Future<void> update(@Body() List<User> users);
}

@ShouldGenerate(
  '''
    final value = GenericUser<dynamic>.fromJson(
      _result.data!,
      (json) => json as dynamic,
    );
    return value;
  ''',
  contains: true,
)
@RestApi()
abstract class DynamicInnerGenericTypeShouldBeCastedAsDynamic {
  @PUT('/')
  Future<GenericUser<dynamic>> get();
}

@ShouldGenerate(
  '''
    final value = GenericUser<List<User>>.fromJson(
      _result.data!,
      (json) => json is List<dynamic>
          ? json
              .map<User>((i) => User.fromJson(i as Map<String, dynamic>))
              .toList()
          : List.empty(),
    );
    return value;
  ''',
  contains: true,
)
@RestApi()
abstract class DynamicInnerListGenericTypeShouldBeCastedRecursively {
  @PUT('/')
  Future<GenericUser<List<User>>> get();
}

@ShouldGenerate(
  '''
    final value = _result.data == null
        ? null
        : GenericUser<List<User>>.fromJson(
            _result.data!,
            (json) => json is List<dynamic>
                ? json
                    .map<User>((i) => User.fromJson(i as Map<String, dynamic>))
                    .toList()
                : List.empty(),
          );
    return value;
  ''',
  contains: true,
)
@RestApi()
abstract class NullableDynamicInnerListGenericTypeShouldBeCastedRecursively {
  @PUT('/')
  Future<GenericUser<List<User>>?> get();
}

@ShouldGenerate(
  '''
    final value = GenericUser<User>.fromJson(
      _result.data!,
      (json) => User.fromJson(json as Map<String, dynamic>),
    );
    return value;
  ''',
  contains: true,
)
@RestApi()
abstract class DynamicInnerGenericTypeShouldBeCastedAsMap {
  @PUT('/')
  Future<GenericUser<User>> get();
}

@ShouldGenerate(
  '''
    final value = GenericUser<GenericUser<User>>.fromJson(
      _result.data!,
      (json) => GenericUser<User>.fromJson(
        json as Map<String, dynamic>,
        (json) => User.fromJson(json as Map<String, dynamic>),
      ),
    );
    return value;
  ''',
  contains: true,
)
@RestApi()
abstract class NestGenericTypeShouldBeCastedRecursively {
  @PUT('/')
  Future<GenericUser<GenericUser<User>>> get();
}

@ShouldGenerate(
  '''
    final value = _result.data == null
        ? null
        : GenericUser<User>.fromJson(
            _result.data!,
            (json) => User.fromJson(json as Map<String, dynamic>),
          );
    return value;
  ''',
  contains: true,
)
@RestApi()
abstract class NullableDynamicInnerGenericTypeShouldBeCastedAsMap {
  @PUT('/')
  Future<GenericUser<User>?> get();
}

@ShouldGenerate(
  '''
    final value = GenericUser<User?>.fromJson(
      _result.data!,
      (json) =>
          json == null ? null : User.fromJson(json as Map<String, dynamic>),
    );
    return value;
  ''',
  contains: true,
)
@RestApi()
abstract class DynamicNullableInnerGenericTypeShouldBeCastedAsMap {
  @PUT('/')
  Future<GenericUser<User?>> get();
}

@ShouldGenerate(
  '''
    final value = _result.data == null
        ? null
        : GenericUser<User?>.fromJson(
            _result.data!,
            (json) => json == null
                ? null
                : User.fromJson(json as Map<String, dynamic>),
          );
    return value;
  ''',
  contains: true,
)
@RestApi()
abstract class NullableDynamicNullableInnerGenericTypeShouldBeCastedAsMap {
  @PUT('/')
  Future<GenericUser<User?>?> get();
}

@ShouldGenerate(
  '''
    final value = GenericUser<List<double>>.fromJson(
      _result.data!,
      (json) => json is List<dynamic>
          ? json.map<double>((i) => i as double).toList()
          : List.empty(),
    );
    return value;
  ''',
  contains: true,
)
@RestApi()
abstract class DynamicInnerListGenericPrimitiveTypeShouldBeCastedRecursively {
  @PUT('/')
  Future<GenericUser<List<double>>> get();
}

@ShouldGenerate(
  '''
    final value = _result.data == null
        ? null
        : GenericUser<List<double>>.fromJson(
            _result.data!,
            (json) => json is List<dynamic>
                ? json.map<double>((i) => i as double).toList()
                : List.empty(),
          );
    return value;
  ''',
  contains: true,
)
@RestApi()
abstract class NullableDynamicInnerListGenericPrimitiveTypeShouldBeCastedRecursively {
  @PUT('/')
  Future<GenericUser<List<double>>?> get();
}

@ShouldGenerate(
  '''
    final value = GenericUserWithoutGenericArgumentFactories<dynamic>.fromJson(
        _result.data!);
    return value;
  ''',
  contains: true,
)
@RestApi()
abstract class DynamicInnerGenericTypeShouldBeWithoutGenericArgumentType {
  @PUT('/')
  Future<GenericUserWithoutGenericArgumentFactories<dynamic>> get();
}

@ShouldGenerate(
  '''
    final value = _result.data == null
        ? null
        : GenericUserWithoutGenericArgumentFactories<dynamic>.fromJson(
            _result.data!);
    return value;
  ''',
  contains: true,
)
@RestApi()
abstract class NullableDynamicInnerGenericTypeShouldBeWithoutGenericArgumentType {
  @PUT('/')
  Future<GenericUserWithoutGenericArgumentFactories<dynamic>?> get();
}

@ShouldGenerate(
  '''
    final String? _data = null;
  ''',
  contains: true,
)
@RestApi()
abstract class NoBodyGeneratesNullBody {
  @PUT('/')
  @NoBody()
  Future<GenericUser<dynamic>> puy();
}

mixin MethodInMixin {
  @GET('https://httpbin.org/')
  Future<void> someGet();
}

@ShouldGenerate(
  '''
  @override
  Future<void> someGet() async {
  ''',
  contains: true,
)
@RestApi()
abstract class NoMethods with MethodInMixin {}

@ShouldGenerate(
  '''await _dio.fetch<Map<String, dynamic>?>''',
  contains: true,
)
@RestApi()
abstract class NullableGenericCastFetch {
  @GET('/')
  Future<User?> get();
}

@ShouldGenerate(
  '''await _dio.fetch<Map<String, dynamic>>''',
  contains: true,
)
@RestApi()
abstract class GenericCastFetch {
  @GET('/')
  Future<User> get();
}

@ShouldGenerate(
  '''
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
  ''',
  contains: true,
)
@RestApi()
abstract class CombineBaseUrls {
  @GET('/')
  Future<User> get();
}
