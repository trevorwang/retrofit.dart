import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import 'package:source_gen_test/annotations.dart';

import 'query.pb.dart';

class Resource<T> {}

class MockCallAdapter1<T> extends CallAdapter<Future<T>, Future<Resource<T>>> {
  @override
  Future<Resource<T>> adapt(Future<T> Function() call) async {
    return Resource();
  }
}

@ShouldGenerate('''
  @override
  Future<Resource<GenericUser<User>>> getUser() {
    return MockCallAdapter1<GenericUser<User>>().adapt(() => _getUser());
  }
''', contains: true)
@RestApi()
abstract class TestCallAdapter1 {
  @UseCallAdapter(MockCallAdapter1)
  @GET('path')
  Future<Resource<GenericUser<User>>> getUser();
}

class Either<L, R> {}

class MockCallAdapter2<T>
    extends CallAdapter<Future<T>, Future<Either<T, String>>> {
  @override
  Future<Either<T, String>> adapt(Future<T> Function() call) async {
    return Either();
  }
}

@ShouldGenerate('''
  @override
  Future<Either<User, String>> getUser() {
    return MockCallAdapter2<User>().adapt(() => _getUser());
  }
''', contains: true)
@RestApi()
abstract class TestCallAdapter2 {
  @UseCallAdapter(MockCallAdapter2)
  @GET('path')
  Future<Either<User, String>> getUser();
}

class Flow<T> {}

class MockCallAdapter3<T> extends CallAdapter<Future<T>, Flow<T>> {
  @override
  Flow<T> adapt(Future<T> Function() call) {
    return Flow();
  }
}

@ShouldGenerate('''
  Future<User> _getUser() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<User>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'path',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late User _value;
    try {
      _value = User.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }
''', contains: true)
@RestApi()
abstract class TestCallAdapter3 {
  @UseCallAdapter(MockCallAdapter3)
  @GET('path')
  Flow<User> getUser();
}

class Config {
  const Config({
    required this.date,
    required this.type,
    required this.shouldReplace,
    required this.subConfig,
  });

  final String date;
  final String type;
  final bool shouldReplace;
  final Map<String, dynamic> subConfig;
}

enum FileType { mp4, mp3 }

class DummyTypedExtras extends TypedExtras {
  const DummyTypedExtras({
    required this.id,
    required this.config,
    required this.fileTypes,
    required this.sources,
    required this.shouldProceed,
    this.canFly,
  });

  final String id;
  final Config config;
  final List<FileType> fileTypes;
  final Set<String> sources;
  final bool shouldProceed;
  final bool? canFly;
}

@ShouldGenerate('''
    final _extra = <String, dynamic>{
      'id': '1234',
      'config': {
        'date': '24-10-2024',
        'type': 'analytics',
        'shouldReplace': true,
        'subConfig': {'date': '24-11-2025'},
      },
      'fileTypes': ['mp3', 'mp4'],
      'sources': {'internet', 'local'},
      'shouldProceed': true,
    };
''', contains: true)
@RestApi()
abstract class TypedExtrasTest {
  @DummyTypedExtras(
    id: '1234',
    config: Config(
      date: '24-10-2024',
      type: 'analytics',
      shouldReplace: true,
      subConfig: {'date': '24-11-2025'},
    ),
    fileTypes: [FileType.mp3, FileType.mp4],
    sources: {'internet', 'local'},
    shouldProceed: true,
  )
  @GET('path')
  Future<void> list();
}

class AnotherDummyTypedExtras extends TypedExtras {
  const AnotherDummyTypedExtras({
    required this.peanutButter,
    required this.mac,
    required this.id,
  });

  final String peanutButter;
  final String mac;
  final String id;
}

@ShouldGenerate('''
    final _extra = <String, dynamic>{
      'bacon': 'sausage',
      'id': '12345',
      'config': {
        'date': '24-10-2024',
        'type': 'analytics',
        'shouldReplace': true,
        'subConfig': {'date': '24-11-2025'},
      },
      'fileTypes': ['mp3', 'mp4'],
      'sources': {'internet', 'local'},
      'shouldProceed': true,
      'peanutButter': 'Jelly',
      'mac': 'Cheese',
    };
''', contains: true)
@RestApi()
abstract class MultipleTypedExtrasTest {
  @DummyTypedExtras(
    id: '1234',
    config: Config(
      date: '24-10-2024',
      type: 'analytics',
      shouldReplace: true,
      subConfig: {'date': '24-11-2025'},
    ),
    fileTypes: [FileType.mp3, FileType.mp4],
    sources: {'internet', 'local'},
    shouldProceed: true,
  )
  @AnotherDummyTypedExtras(peanutButter: 'Jelly', mac: 'Cheese', id: '12345')
  @Extra({'bacon': 'sausage'})
  @GET('path')
  Future<void> list();
}

@ShouldGenerate('''
// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter

class _RestClient implements RestClient {
  _RestClient(this._dio, {this.baseUrl, this.errorLogger});

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;
''', contains: true)
@RestApi()
abstract class RestClient {}

@ShouldGenerate('''
class _BaseUrl implements BaseUrl {
  _BaseUrl(this._dio, {this.baseUrl, this.errorLogger}) {
    baseUrl ??= 'http://httpbin.org/';
  }

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;
''', contains: true)
@RestApi(baseUrl: 'http://httpbin.org/')
abstract class BaseUrl {}

@ShouldGenerate('''
    final _extra = <String, dynamic>{};
''', contains: true)
@RestApi()
abstract class EmptyExtras {
  @GET('/list/')
  @Extra({})
  Future<void> list();
}

@ShouldGenerate('''
    final _extra = <String, dynamic>{'key': 'value'};
''', contains: true)
@RestApi()
abstract class ExtrasWithPrimitiveValues {
  @GET('/list/')
  @Extra({'key': 'value'})
  Future<void> list();
}

@ShouldGenerate('''
    final _extra = <String, dynamic>{'key': 'value', 'key2': 'value2'};
''', contains: true)
@RestApi()
abstract class MultipleExtrasWithPrimitiveValues {
  @GET('/list/')
  @Extra({'key': 'value'})
  @Extra({'key2': 'value2'})
  Future<void> list();
}

@ShouldGenerate('''
    final _extra = <String, dynamic>{'key': CustomConstant()};
''', contains: true)
@RestApi()
abstract class ExtrasWithCustomConstant {
  @GET('/list/')
  @Extra({'key': CustomConstant()})
  Future<void> list();
}

@ShouldGenerate('''
    final _extra = <String, dynamic>{};
    _extra.addAll(extras ?? <String, dynamic>{});
''', contains: true)
@RestApi()
abstract class TestExtrasWithNullable {
  @GET('/list/')
  Future<void> list(@Extras() Map<String, dynamic>? extras);
}

@ShouldGenerate('''
    final _extra = <String, dynamic>{'key': 'value'};
    _extra.addAll(extras);
''', contains: true)
@RestApi()
abstract class TestExtrasWithMap {
  @GET('/list/')
  @Extra({'key': 'value'})
  Future<void> list(@Extras() Map<String, dynamic> extras);
}

@ShouldGenerate('''
    final _extra = <String, dynamic>{};
    _extra.addAll(u.toJson());
''', contains: true)
@RestApi()
abstract class TestExtrasWithObject {
  @GET('/list/')
  Future<void> list(@Extras() User u);
}

class CustomConstant {
  const CustomConstant();
}

@ShouldGenerate('''
    final _headers = <String, dynamic>{};
''', contains: true)
@RestApi()
abstract class EmptyHeaders {
  @GET('/list/')
  @Headers(<String, dynamic>{})
  Future<void> list();
}

@ShouldGenerate('''
    final _headers = <String, dynamic>{r'key': 'value'};
''', contains: true)
@RestApi()
abstract class HeadersWithPrimitiveValues {
  @GET('/list/')
  @Headers(<String, dynamic>{'key': 'value'})
  Future<void> list();
}

@ShouldGenerate('''
    final _headers = <String, dynamic>{r'key': 'value', r'key2': 'value2'};
''', contains: true)
@RestApi()
abstract class MultipleHeadersWithPrimitiveValues {
  @GET('/list/')
  @Headers(<String, dynamic>{'key': 'value'})
  @Headers(<String, dynamic>{'key2': 'value2'})
  Future<void> list();
}

@ShouldGenerate('''
      Options(method: 'GET', headers: _headers, extra: _extra)
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class HttpGetTest {
  @GET('/get')
  Future<String> ip();
}

@ShouldGenerate('''
      Options(method: 'POST', headers: _headers, extra: _extra)
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class HttpPostTest {
  @POST('/post')
  Future<String> ip();
}

@ShouldGenerate('''
      Options(method: 'PUT', headers: _headers, extra: _extra)
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class HttpPutTest {
  @PUT('/put')
  Future<String> ip();
}

@ShouldGenerate('''
      Options(method: 'DELETE', headers: _headers, extra: _extra)
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class HttpDeleteTest {
  @DELETE('/delete')
  Future<String> ip();
}

@ShouldGenerate('''
      Options(method: 'PATCH', headers: _headers, extra: _extra)
''', contains: true)
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

@ShouldGenerate("contentType: 'multipart/form-data'", contains: true)
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

@ShouldGenerate(r'/image/${imageType}/${id}_XL.png', contains: true)
@RestApi()
abstract class PathTest {
  @GET('/image/{imageType}/{id}_XL.png')
  Future<HttpResponse<dynamic>> getImage(
    @Path('imageType') ImageType imageType,
    @Path('id') String id,
  );
}

@ShouldGenerate(r'/image/${imageType}/${id}/${id}_XL.png', contains: true)
@RestApi()
abstract class MultiplePathTest {
  @GET('/image/{imageType}/{id}/{id}_XL.png')
  Future<HttpResponse<dynamic>> getImage(
    @Path('imageType') ImageType imageType,
    @Path('id') String id,
  );
}

enum ImageType { icon, large }

@ShouldGenerate('''
    final _data = FormData();
    _data.files.add(
      MapEntry(
        'image',
        MultipartFile.fromFileSync(
          image.path,
          filename: image.path.split(Platform.pathSeparator).last,
        ),
      ),
    );
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class FilePartTest {
  @POST('/profile')
  Future<String> setProfile(@Part() File image);
}

@ShouldGenerate('''
    final _data = FormData();
    _data.files.add(
      MapEntry(
        'image',
        MultipartFile.fromFileSync(
          image.path,
          filename: 'my_profile_image.jpg',
        ),
      ),
    );
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class FilePartWithCustomNameTest {
  @POST('/profile')
  Future<String> setProfile(
    @Part(name: 'image', fileName: 'my_profile_image.jpg') File image,
  );
}

@ShouldGenerate('''
    final _data = FormData();
    _data.files.addAll(images.map((i) => MapEntry('images', i)));
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class FilePartWithMultipartListTest {
  @POST('/profile')
  Future<String> setProfile(@Part() List<MultipartFile> images);
}

@ShouldGenerate('''
    final _data = FormData();
    if (images != null) {
      _data.files.addAll(images.map((i) => MapEntry('images', i)));
    }
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class FilePartWithNullableMultipartListTest {
  @POST('/profile')
  Future<String> setProfile(@Part() List<MultipartFile>? images);
}

@ShouldGenerate('''
    final _data = FormData();
    _data.files.add(MapEntry('image', image));
''',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class SingleMultipartFilePartTest {
  @POST('/profile')
  Future<String> setProfile(@Part() MultipartFile image);
}

@ShouldGenerate(
  '''
    final _data = FormData();
    if (image != null) {
      _data.files.add(MapEntry('image', image));
    }
''',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class SingleNullableMultipartFilePartTest {
  @POST('/profile')
  Future<String> setProfile(@Part() MultipartFile? image);
}

@ShouldGenerate(
  '''
    final _data = FormData();
    _data.files.add(
      MapEntry(
        'image',
        MultipartFile.fromFileSync(
          image.path,
          filename: image.path.split(Platform.pathSeparator).last,
        ),
      ),
    );
  ''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class UploadFileInfoPartTest {
  @POST('/profile')
  Future<String> setProfile(@Part() File image);
}

@ShouldGenerate('''
    late User _value;
    try {
      _value = User.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class GenericCast {
  @POST('/users/1')
  Future<User> getUser();
}

@ShouldGenerate('''
    late User? _value;
    try {
      _value = _result.data == null ? null : User.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class NullableGenericCast {
  @POST('/users/1')
  Future<User?> getUser();
}

@ShouldGenerate('''
    late User _value;
    try {
      _value = User.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    yield _value;
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class StreamReturnType {
  @POST('/users/1')
  Stream<User> getUser();
}

enum TestEnum { A, B }

@ShouldGenerate(r'''
    late TestEnum _value;
    try {
      _value = TestEnum.values.firstWhere(
        (e) => e.name == _result.data,
        orElse: () => throw ArgumentError(
          'TestEnum does not contain value ${_result.data}',
        ),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
''', contains: true)
@RestApi()
abstract class EnumReturnType {
  @GET('/')
  Future<TestEnum> getTestEnum();
}

enum EnumParam { enabled, disabled }

@ShouldGenerate('''
    final queryParameters = <String, dynamic>{r'test': status};
''', contains: true)
@RestApi()
abstract class TestQueryParamEnum {
  @GET('/test')
  Future<void> getTest(@Query('test') EnumParam? status);
}

enum FromJsonEnum {
  a('a'),
  b('b');

  const FromJsonEnum(this.json);

  factory FromJsonEnum.fromJson(String json) =>
      values.firstWhere((e) => e.json == json);

  final String json;
}

@ShouldGenerate('''
    late FromJsonEnum _value;
    try {
      _value = FromJsonEnum.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
''', contains: true)
@RestApi()
abstract class EnumFromJsonReturnType {
  @GET('/')
  Future<FromJsonEnum> getTestEnum();
}

enum ToJsonEnum {
  plus(1),
  minus(-1);

  const ToJsonEnum(this.value);

  final int value;

  int toJson() => value;
}

@ShouldGenerate('''
    final queryParameters = <String, dynamic>{r'test': status?.toJson()};
''', contains: true)
@RestApi()
abstract class TestQueryParamEnumToJson {
  @GET('/test')
  Future<void> getTest(@Query('test') ToJsonEnum? status);
}

@ShouldGenerate('''
  Stream<User> getUser() async* {
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class StreamReturnModifier {
  @POST('/users/1')
  Stream<User> getUser();
}

class UserExtraInfo {
  const UserExtraInfo();

  // ignore: avoid_unused_constructor_parameters
  factory UserExtraInfo.fromJson(Map<String, Object?> json) =>
      const UserExtraInfo();

  Map<String, dynamic> toJson() => <String, dynamic>{};
}

class User implements AbstractUser {
  const User();

  // ignore: avoid_unused_constructor_parameters
  factory User.fromJson(Map<String, dynamic> json) => const User();

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

abstract interface class AbstractUser with AbstractUserMixin {
  factory AbstractUser.fromJson(Map<String, dynamic> json) =>
      User.fromJson(json);
}

Map<String, dynamic> serializeUser(User object) => object.toJson();

@ShouldGenerate('''
    late String _value;
    try {
      _value = _result.data!;
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class GenericCastBasicType {
  @POST('/users/1')
  Future<String> getUser();
}

@ShouldGenerate('''
    late String? _value;
    try {
      _value = _result.data;
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class NullableGenericCastBasicType {
  @POST('/users/1')
  Future<String?> getUser();
}

@ShouldGenerate('''
    final _data = <String, dynamic>{};
    _data.addAll(user.toJson());
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TestObjectBody {
  @POST('/users')
  Future<String> createUser(@Body() User user);
}

@ShouldGenerate('''
  Future<String> createUser({required dynamic user}) async {
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TestDynamicRequiredBody {
  @POST('/users')
  // ignore: avoid_annotating_with_dynamic
  Future<String> createUser({@Body() required dynamic user});
}

@ShouldGenerate('''
  Future<String> createUser({dynamic user}) async {
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TestDynamicBody {
  @POST('/users')
  // ignore: avoid_annotating_with_dynamic
  Future<String> createUser({@Body() dynamic user});
}

@ShouldGenerate('''
    final _data = <String, dynamic>{'user_id': userId};
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TestObjectSingleBodyExtra {
  @POST('/users')
  Future<String> createUser(@BodyExtra('user_id') String userId);
}

@ShouldGenerate('''
    final _data = <String, dynamic>{'user_id': userId};
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TestObjectSingleBodyExtra1 {
  @POST('/users')
  Future<String> createUser({@BodyExtra('user_id') required String userId});
}

@ShouldGenerate('''
    final _data = <String, dynamic>{'update_timestamp': timestamp};
    _data.addAll(user.toJson());
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TestObjectBodyExtra {
  @POST('/users')
  Future<String> createUser(
    @Body() User user, {
    @BodyExtra('update_timestamp') required int timestamp,
  });
}

@ShouldGenerate('''
    final _data = <String, dynamic>{
      'user_name': userName,
      'update_timestamp': timestamp,
    };
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TestObjectBodyExtraWithoutBody {
  @POST('/users')
  Future<String> createUser({
    @BodyExtra('user_name') required String userName,
    @BodyExtra('update_timestamp') required int timestamp,
  });
}

@ShouldGenerate('''
    final _data = <String, dynamic>{'update_timestamp': timestamp};
    _data.addAll(user?.toJson() ?? <String, dynamic>{});
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TestObjectBodyExtraOptional {
  @POST('/users')
  Future<String> createUser({
    @BodyExtra('user', expand: true) User? user,
    @BodyExtra('update_timestamp') int? timestamp,
  });
}

@ShouldGenerate('''
    final _data = <String, dynamic>{};
    _data.addAll(user.toJson());
    _data.addAll(extraInfo.toJson());
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TestObjectBodyExtraMultiExpandObject {
  @POST('/users')
  Future<String> createUser({
    @BodyExtra('user', expand: true) required User user,
    @BodyExtra('extra_info', expand: true) required UserExtraInfo extraInfo,
  });
}

@ShouldGenerate('''
    final _data = <String, dynamic>{};
    _data.addAll(user?.toJson() ?? <String, dynamic>{});
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TestObjectBodyNullable {
  @POST('/users')
  Future<String> createUser({@Body() User? user});
}

@ShouldGenerate('''
    final _data = <String, dynamic>{};
    _data.addAll(user.toJson());
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TestAbstractObjectBody {
  @POST('/users')
  Future<String> createUser(@Body() AbstractUser user);
}

@ShouldGenerate('''
    final _data = <String, dynamic>{};
    _data.addAll(user?.toJson() ?? <String, dynamic>{});
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TestAbstractObjectBodyNullable {
  @POST('/users')
  Future<String> createUser({@Body() AbstractUser? user});
}

@ShouldGenerate('''
    final queryParameters = <String, dynamic>{r'u': u.toJson()};
    queryParameters.addAll(user1.toJson());
    queryParameters.addAll(user2.toJson());
''', contains: true)
@ShouldGenerate('''
    final queryParameters = <String, dynamic>{r'u': u.toJson()};
    queryParameters.addAll(user3?.toJson() ?? <String, dynamic>{});
    queryParameters.addAll(user4?.toJson() ?? <String, dynamic>{});
''', contains: true)
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

@ShouldGenerate('''
    final queryParameters = <String, dynamic>{r'test': date?.toIso8601String()};
''', contains: true)
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

@ShouldGenerate('''
    late Map<String, List<User>> _value;
    try {
      _value = _result.data!.map(
        (k, dynamic v) => MapEntry(
          k,
          (v as List)
              .map((i) => User.fromJson(i as Map<String, dynamic>))
              .toList(),
        ),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TestMapBody {
  @GET('/xx')
  Future<Map<String, List<User>>> getResult();
}

@ShouldGenerate('''
    late Map<String, List<User>>? _value;
    try {
      _value = _result.data?.map(
        (k, dynamic v) => MapEntry(
          k,
          (v as List)
              .map((i) => User.fromJson(i as Map<String, dynamic>))
              .toList(),
        ),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class NullableTestMapBody {
  @GET('/xx')
  Future<Map<String, List<User>>?> getResult();
}

@ShouldGenerate('''
    late Map<String, User> _value;
    try {
      _value = _result.data!.map(
        (k, dynamic v) => MapEntry(k, User.fromJson(v as Map<String, dynamic>)),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TestMapBody2 {
  @GET('/xx')
  Future<Map<String, User>> getResult();
}

@ShouldGenerate('''
    late Map<String, User>? _value;
    try {
      _value = _result.data?.map(
        (k, dynamic v) => MapEntry(k, User.fromJson(v as Map<String, dynamic>)),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class NullableTestMapBody2 {
  @GET('/xx')
  Future<Map<String, User>?> getResult();
}

@ShouldGenerate('''
    late List<String> _value;
    try {
      _value = _result.data!.cast<String>();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TestBasicListString {
  @GET('/xx')
  Future<List<String>> getResult();
}

@ShouldGenerate('''
    late List<String>? _value;
    try {
      _value = _result.data?.cast<String>();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class NullableTestBasicListString {
  @GET('/xx')
  Future<List<String>?> getResult();
}

@ShouldGenerate('''
    late List<bool> _value;
    try {
      _value = _result.data!.cast<bool>();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TestBasicListBool {
  @GET('/xx')
  Future<List<bool>> getResult();
}

@ShouldGenerate('''
    late List<bool>? _value;
    try {
      _value = _result.data?.cast<bool>();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class NullableTestBasicListBool {
  @GET('/xx')
  Future<List<bool>?> getResult();
}

@ShouldGenerate('''
    late List<int> _value;
    try {
      _value = _result.data!.cast<int>();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TestBasicListInt {
  @GET('/xx')
  Future<List<int>> getResult();
}

@ShouldGenerate('''
    late List<int>? _value;
    try {
      _value = _result.data?.cast<int>();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class NullableTestBasicListInt {
  @GET('/xx')
  Future<List<int>?> getResult();
}

@ShouldGenerate('''
    late List<double> _value;
    try {
      _value = _result.data!.cast<double>();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TestBasicListDouble {
  @GET('/xx')
  Future<List<double>> getResult();
}

@ShouldGenerate('''
    late List<double>? _value;
    try {
      _value = _result.data?.cast<double>();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class NullableTestBasicListDouble {
  @GET('/xx')
  Future<List<double>?> getResult();
}

@ShouldGenerate('cancelToken: cancelToken', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TestCancelToken {
  @POST('/users')
  Future<String> createUser(
    @Body() User user,
    @CancelRequest() CancelToken cancelToken,
  );
}

@ShouldGenerate('onSendProgress: onSendProgress', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TestSendProgress {
  @POST('/users')
  Future<String> createUser(
    @Body() User user,
    @SendProgress() ProgressCallback onSendProgress,
  );
}

@ShouldGenerate('onReceiveProgress: onReceiveProgress', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TestReceiveProgress {
  @POST('/users')
  Future<String> createUser(
    @Body() User user,
    @ReceiveProgress() ProgressCallback onReceiveProgress,
  );
}

@ShouldGenerate('''
      Options(method: 'HEAD', headers: _headers, extra: _extra)
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TestHeadMethod {
  @HEAD('/')
  Future<String> testHeadMethod();
}

@ShouldGenerate('''
      Options(method: 'OPTIONS', headers: _headers, extra: _extra)
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/')
abstract class TestOptionsMethod {
  @OPTIONS('/')
  Future<String> testOptionsMethod();
}

@ShouldGenerate('''
    final httpResponse = HttpResponse(null, _result);
''', contains: true)
@RestApi()
abstract class TestHttpResponseVoid {
  @GET('/')
  Future<HttpResponse<void>> noResponseData();
}

@ShouldGenerate('''
    final httpResponse = HttpResponse(_value, _result);
''', contains: true)
@RestApi()
abstract class TestHttpResponseObject {
  @GET('/')
  Future<HttpResponse<Map<String, dynamic>>> responseWithObject();
}

@ShouldGenerate('''
    late List<String> _value;
    try {
      _value = _result.data!.cast<String>();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    final httpResponse = HttpResponse(_value, _result);
    return httpResponse;
''', contains: true)
@RestApi()
abstract class TestHttpResponseArray {
  @GET('/')
  Future<HttpResponse<List<String>>> responseWithArray();
}

@ShouldGenerate('''
    final _data = FormData();
    _data.files.addAll(
      files.map(
        (i) => MapEntry(
          'files',
          MultipartFile.fromFileSync(
            i.path,
            filename: i.path.split(Platform.pathSeparator).last,
          ),
        ),
      ),
    );
''', contains: true)
@ShouldGenerate('''
    final _data = FormData();
    if (files != null) {
      _data.files.addAll(
        files.map(
          (i) => MapEntry(
            'files',
            MultipartFile.fromFileSync(
              i.path,
              filename: i.path.split(Platform.pathSeparator).last,
            ),
          ),
        ),
      );
    }
''', contains: true)
@ShouldGenerate('''
    final _data = FormData();
    if (file != null) {
      _data.files.add(
        MapEntry(
          'file',
          MultipartFile.fromFileSync(
            file.path,
            filename: file.path.split(Platform.pathSeparator).last,
          ),
        ),
      );
    }
''', contains: true)
@RestApi()
abstract class TestFileList {
  @POST('/')
  Future<void> testFileList(@Part() List<File> files);

  @POST('/')
  Future<void> testOptionalFileList(@Part() List<File>? files);

  @POST('/')
  Future<void> testOptionalFile({@Part() File file});
}

// @JsonEnum()
enum TestEnumWithToJson {
  // @JsonValue('A')
  A('A'),
  // @JsonValue('B')
  B('B');

  const TestEnumWithToJson(this.json);

  final String? json;

  String? toJson() => json;
}

@ShouldGenerate(
  "_data.fields.add(MapEntry('users', jsonEncode(users)));",
  contains: true,
)
@ShouldGenerate(
  "_data.fields.add(MapEntry('item', jsonEncode(user)));",
  contains: true,
)
@ShouldGenerate('''
    final _data = FormData();
    mapList.forEach((i) {
      _data.fields.add(MapEntry('mapList', jsonEncode(i)));
    });
''', contains: true)
@ShouldGenerate('''
    final _data = FormData.fromMap(map);
''', contains: true)
@ShouldGenerate('''
_data.fields.add(MapEntry('enumValue', enumValue));
''', contains: true)
@ShouldGenerate('''
    _data.fields.add(MapEntry('enumValue', enumValue.toJson() ?? enumValue));
''', contains: true)
@ShouldGenerate('''
    final _data = FormData();
    _data.fields.add(MapEntry('a', a.toString()));
    _data.fields.add(MapEntry('b', b.toString()));
    if (c != null) {
      _data.fields.add(MapEntry('c', c));
    }
    _data.fields.add(MapEntry('d', d.toString()));
''', contains: true)
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
  Future<void> testEnum(@Part() TestEnum enumValue);

  @POST('/')
  Future<void> testEnumWithToJsonType(@Part() TestEnumWithToJson enumValue);

  @POST('/')
  Future<void> testBasicType(
    @Part() int a,
    @Part() double b, {
    @Part() String? c,
    @Part() bool d,
  });
}

@ShouldGenerate('''
    final newOptions = newRequestOptions(options);
    newOptions.extra.addAll(_extra);
    newOptions.headers.addAll(_dio.options.headers);
    newOptions.headers.addAll(_headers);
    final _options = newOptions.copyWith(
      method: 'GET',
      baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl),
      queryParameters: queryParameters,
      path: '',
    )..data = _data;
''', contains: true)
@ShouldGenerate('''
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
''', contains: true)
@RestApi()
abstract class CustomOptions {
  @GET('')
  Future<void> testOptions(@DioOptions() Options options);
}

@ShouldGenerate('''
    late User _value;
    try {
      _value = JsonMapper.fromMap<User>(_result.data!)!;
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/', parser: Parser.DartJsonMapper)
abstract class JsonMapperGenericCast {
  @POST('/xx')
  Future<User> getUser();
}

@ShouldGenerate('''
    late User? _value;
    try {
      _value = _result.data == null
          ? null
          : JsonMapper.fromMap<User>(_result.data!)!;
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/', parser: Parser.DartJsonMapper)
abstract class NullableJsonMapperGenericCast {
  @POST('/xx')
  Future<User?> getUser();
}

@ShouldGenerate('''
    late List<User> _value;
    try {
      _value = _result.data!
          .map(
            (dynamic i) => JsonMapper.fromMap<User>(i as Map<String, dynamic>)!,
          )
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/', parser: Parser.DartJsonMapper)
abstract class JsonMapperTestListBody {
  @GET('/xx')
  Future<List<User>> getResult();
}

@ShouldGenerate('''
    late Map<String, List<User>> _value;
    try {
      _value = _result.data!.map(
        (k, dynamic v) => MapEntry(
          k,
          (v as List)
              .map((i) => JsonMapper.fromMap<User>(i as Map<String, dynamic>)!)
              .toList(),
        ),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/', parser: Parser.DartJsonMapper)
abstract class JsonMapperTestMapBody {
  @GET('/xx')
  Future<Map<String, List<User>>> getResult();
}

@ShouldGenerate('''
    late Map<String, User> _value;
    try {
      _value = _result.data!.map(
        (k, dynamic v) =>
            MapEntry(k, JsonMapper.fromMap<User>(v as Map<String, dynamic>)!),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/', parser: Parser.DartJsonMapper)
abstract class JsonMapperTestMapBody2 {
  @GET('/xx')
  Future<Map<String, User>> getResult();
}

@ShouldGenerate('''
    late User _value;
    try {
      _value = User.fromMap(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/', parser: Parser.MapSerializable)
abstract class MapSerializableGenericCast {
  @POST('/xx')
  Future<User> getUser();
}

@ShouldGenerate('''
    late User? _value;
    try {
      _value = _result.data == null ? null : User.fromMap(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/', parser: Parser.MapSerializable)
abstract class NullableMapSerializableGenericCast {
  @POST('/xx')
  Future<User?> getUser();
}

@ShouldGenerate('''
    late List<User> _value;
    try {
      _value = _result.data!
          .map((dynamic i) => User.fromMap(i as Map<String, dynamic>))
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/', parser: Parser.MapSerializable)
abstract class MapSerializableTestListBody {
  @GET('/xx')
  Future<List<User>> getResult();
}

@ShouldGenerate('''
    late List<User>? _value;
    try {
      _value = _result.data
          ?.map((dynamic i) => User.fromMap(i as Map<String, dynamic>))
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/', parser: Parser.MapSerializable)
abstract class NullableMapSerializableTestListBody {
  @GET('/xx')
  Future<List<User>?> getResult();
}

@ShouldGenerate('''
    late Map<String, List<User>> _value;
    try {
      _value = _result.data!.map(
        (k, dynamic v) => MapEntry(
          k,
          (v as List)
              .map((i) => User.fromMap(i as Map<String, dynamic>))
              .toList(),
        ),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/', parser: Parser.MapSerializable)
abstract class MapSerializableTestMapBody {
  @GET('/xx')
  Future<Map<String, List<User>>> getResult();
}

@ShouldGenerate('''
    late Map<String, List<User>>? _value;
    try {
      _value = _result.data?.map(
        (k, dynamic v) => MapEntry(
          k,
          (v as List)
              .map((i) => User.fromMap(i as Map<String, dynamic>))
              .toList(),
        ),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/', parser: Parser.MapSerializable)
abstract class NullableMapSerializableTestMapBody {
  @GET('/xx')
  Future<Map<String, List<User>>?> getResult();
}

@ShouldGenerate('''
    late Map<String, User> _value;
    try {
      _value = _result.data!.map(
        (k, dynamic v) => MapEntry(k, User.fromMap(v as Map<String, dynamic>)),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/', parser: Parser.MapSerializable)
abstract class MapSerializableTestMapBody2 {
  @GET('/xx')
  Future<Map<String, User>> getResult();
}

@ShouldGenerate('''
    late Map<String, User>? _value;
    try {
      _value = _result.data?.map(
        (k, dynamic v) => MapEntry(k, User.fromMap(v as Map<String, dynamic>)),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/', parser: Parser.MapSerializable)
abstract class NullableMapSerializableTestMapBody2 {
  @GET('/xx')
  Future<Map<String, User>?> getResult();
}

@ShouldGenerate('''
    try {
      _value = await compute(deserializeUser, _result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/', parser: Parser.FlutterCompute)
abstract class ComputeGenericCast {
  @POST('/xx')
  Future<User> getUser();
}

@ShouldGenerate('''
    late User? _value;
    try {
      _value = _result.data == null
          ? null
          : await compute(deserializeUser, _result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/', parser: Parser.FlutterCompute)
abstract class NullableComputeGenericCast {
  @POST('/xx')
  Future<User?> getUser();
}

@ShouldGenerate('''
    try {
      _value = await compute(
        deserializeUserList,
        _result.data!.cast<Map<String, dynamic>>(),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/', parser: Parser.FlutterCompute)
abstract class ComputeTestListBody {
  @GET('/xx')
  Future<List<User>> getResult();
}

@ShouldGenerate('''
    late List<User>? _value;
    try {
      _value = _result.data == null
          ? null
          : await compute(
              deserializeUserList,
              _result.data!.cast<Map<String, dynamic>>(),
            );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
  ''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/', parser: Parser.FlutterCompute)
abstract class NullableComputeTestListBody {
  @GET('/xx')
  Future<List<User>?> getResult();
}

@ShouldGenerate(
  '''
    late Map<String, List<User>> _value;
    try {
      _value = Map.fromEntries(
        await Future.wait(
          _result.data!.entries.map(
            (e) async => MapEntry(
              e.key,
              await compute(
                deserializeUserList,
                (e.value as List).cast<Map<String, dynamic>>(),
              ),
            ),
          ),
        ),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
''',
  contains: true,
  expectedLogItems: [
    '''
Return types should not be a map when running `Parser.FlutterCompute`, as spawning an isolate per entry is extremely intensive.
You should create a new class to encapsulate the response.
''',
  ],
)
@RestApi(baseUrl: 'https://httpbin.org/', parser: Parser.FlutterCompute)
abstract class ComputeTestMapBody {
  @GET('/xx')
  Future<Map<String, List<User>>> getResult();
}

@ShouldGenerate(
  '''
    late Map<String, List<User>>? _value;
    try {
      _value = Map.fromEntries(
        await Future.wait(
          _result.data!.entries.map(
            (e) async => MapEntry(
              e.key,
              await compute(
                deserializeUserList,
                (e.value as List).cast<Map<String, dynamic>>(),
              ),
            ),
          ),
        ),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
''',
  contains: true,
  expectedLogItems: [
    '''
Return types should not be a map when running `Parser.FlutterCompute`, as spawning an isolate per entry is extremely intensive.
You should create a new class to encapsulate the response.
''',
  ],
)
@RestApi(baseUrl: 'https://httpbin.org/', parser: Parser.FlutterCompute)
abstract class NullableComputeTestMapBody {
  @GET('/xx')
  Future<Map<String, List<User>>?> getResult();
}

@ShouldGenerate(
  '''
    late Map<String, User> _value;
    try {
      _value = Map.fromEntries(
        await Future.wait(
          _result.data!.entries.map(
            (e) async => MapEntry(
              e.key,
              await compute(deserializeUser, e.value as Map<String, dynamic>),
            ),
          ),
        ),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
''',
  contains: true,
  expectedLogItems: [
    '''
Return types should not be a map when running `Parser.FlutterCompute`, as spawning an isolate per entry is extremely intensive.
You should create a new class to encapsulate the response.
''',
  ],
)
@RestApi(baseUrl: 'https://httpbin.org/', parser: Parser.FlutterCompute)
abstract class ComputeTestMapBody2 {
  @GET('/xx')
  Future<Map<String, User>> getResult();
}

@ShouldGenerate(
  '''
    late Map<String, User>? _value;
    try {
      _value = _result.data == null
          ? null
          : Map.fromEntries(
              await Future.wait(
                _result.data!.entries.map(
                  (e) async => MapEntry(
                    e.key,
                    await compute(
                      deserializeUser,
                      e.value as Map<String, dynamic>,
                    ),
                  ),
                ),
              ),
            );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
''',
  contains: true,
  expectedLogItems: [
    '''
Return types should not be a map when running `Parser.FlutterCompute`, as spawning an isolate per entry is extremely intensive.
You should create a new class to encapsulate the response.
''',
  ],
)
@RestApi(baseUrl: 'https://httpbin.org/', parser: Parser.FlutterCompute)
abstract class NullableComputeTestMapBody2 {
  @GET('/xx')
  Future<Map<String, User>?> getResult();
}

@ShouldGenerate('''
    final queryParameters = <String, dynamic>{
      r'u': await compute(serializeUser, user),
    };
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/', parser: Parser.FlutterCompute)
abstract class ComputeQuery {
  @GET('/xx')
  Future<void> getResult(@Query('u') User user);
}

@ShouldGenerate('''
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(await compute(serializeUser, user));
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/', parser: Parser.FlutterCompute)
abstract class ComputeQueries {
  @GET('/xx')
  Future<void> getResult(@Queries() User user);
}

@ShouldGenerate('''
    final _data = <String, dynamic>{};
    _data.addAll(await compute(serializeUser, user));
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/', parser: Parser.FlutterCompute)
abstract class TestComputeObjectBody {
  @GET('/xx')
  Future<void> getResult(@Body() User user);
}

@ShouldGenerate('''
    final _data = await compute(serializeUserList, users);
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/', parser: Parser.FlutterCompute)
abstract class TestComputeObjectListBody {
  @GET('/xx')
  Future<void> getResult(@Body() List<User> users);
}

@ShouldGenerate('''
    final _data = <String, dynamic>{};
    _data.addAll(
      user == null ? <String, dynamic>{} : await compute(serializeUser, user),
    );
''', contains: true)
@RestApi(baseUrl: 'https://httpbin.org/', parser: Parser.FlutterCompute)
abstract class TestComputeNullableObjectBody {
  @GET('/xx')
  Future<void> getResult(@Body() User? user);
}

@ShouldGenerate(
  '    final _data = user?.map((e) => e.toJson()).toList();',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/', parser: Parser.JsonSerializable)
abstract class TestComputeNullableObjectListBodyJsonSerializable {
  @GET('/xx')
  Future<void> getResult(@Body() List<User>? user);
}

@ShouldGenerate(
  '    final _data = user == null ? null : await compute(serializeUserList, user);',
  contains: true,
)
@RestApi(baseUrl: 'https://httpbin.org/', parser: Parser.FlutterCompute)
abstract class TestComputeNullableObjectListBodyFlutterCompute {
  @GET('/xx')
  Future<void> getResult(@Body() List<User>? user);
}

@ShouldGenerate('_data.removeWhere((k, v) => v == null);', contains: true)
@RestApi()
abstract class MapBodyShouldBeCleanTest {
  @PUT('/')
  Future<void> update(@Body(nullToAbsent: true) Map<String, dynamic> data);
}

@ShouldGenerate('_data.removeWhere((k, v) => v == null);', contains: true)
@RestApi()
abstract class JsonSerializableBodyShouldBeCleanTest {
  @PUT('/')
  Future<void> update(@Body(nullToAbsent: true) User obj);
}

@ShouldGenerate(
  '''
    final _data = str;
    final _options = _setStreamType<void>(
''',
  contains: true,
  expectedLogItems: [
    "String must provide a `toJson()` method which return a Map.\nIt is programmer's responsibility to make sure the String is properly serialized",
  ],
)
@RestApi()
abstract class NonJsonSerializableBodyShouldNotBeCleanTest {
  @PUT('/')
  Future<void> update(@Body() String str);
}

@ShouldGenerate('''
    final _data = users.map((e) => e.toJson()).toList();
    final _options = _setStreamType<void>(
      Options(method: 'PUT', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    await _dio.fetch<void>(_options);
''', contains: true)
@RestApi()
abstract class ListBodyShouldNotBeCleanTest {
  @PUT('/')
  Future<void> update(@Body() List<User> users);
}

@ShouldGenerate('''
    late GenericUser<dynamic> _value;
    try {
      _value = GenericUser<dynamic>.fromJson(
        _result.data!,
        (json) => json as dynamic,
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
''', contains: true)
@RestApi()
abstract class DynamicInnerGenericTypeShouldBeCastedAsDynamic {
  @PUT('/')
  Future<GenericUser<dynamic>> get();
}

@ShouldGenerate('''
    late GenericUser<List<User>> _value;
    try {
      _value = GenericUser<List<User>>.fromJson(
        _result.data!,
        (json) => json is List<dynamic>
            ? json
                  .map<User>((i) => User.fromJson(i as Map<String, dynamic>))
                  .toList()
            : List.empty(),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
''', contains: true)
@RestApi()
abstract class DynamicInnerListGenericTypeShouldBeCastedRecursively {
  @PUT('/')
  Future<GenericUser<List<User>>> get();
}

@ShouldGenerate('''
    late GenericUser<List<User>>? _value;
    try {
      _value = _result.data == null
          ? null
          : GenericUser<List<User>>.fromJson(
              _result.data!,
              (json) => json is List<dynamic>
                  ? json
                        .map<User>(
                          (i) => User.fromJson(i as Map<String, dynamic>),
                        )
                        .toList()
                  : List.empty(),
            );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
''', contains: true)
@RestApi()
abstract class NullableDynamicInnerListGenericTypeShouldBeCastedRecursively {
  @PUT('/')
  Future<GenericUser<List<User>>?> get();
}

@ShouldGenerate('''
    late GenericUser<User> _value;
    try {
      _value = GenericUser<User>.fromJson(
        _result.data!,
        (json) => User.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
''', contains: true)
@RestApi()
abstract class DynamicInnerGenericTypeShouldBeCastedAsMap {
  @PUT('/')
  Future<GenericUser<User>> get();
}

@ShouldGenerate('''
    late GenericUser<GenericUser<User>> _value;
    try {
      _value = GenericUser<GenericUser<User>>.fromJson(
        _result.data!,
        (json) => GenericUser<User>.fromJson(
          json as Map<String, dynamic>,
          (json) => User.fromJson(json as Map<String, dynamic>),
        ),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
''', contains: true)
@RestApi()
abstract class NestGenericTypeShouldBeCastedRecursively {
  @PUT('/')
  Future<GenericUser<GenericUser<User>>> get();
}

@ShouldGenerate('''
    late GenericUser<User>? _value;
    try {
      _value = _result.data == null
          ? null
          : GenericUser<User>.fromJson(
              _result.data!,
              (json) => User.fromJson(json as Map<String, dynamic>),
            );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
''', contains: true)
@RestApi()
abstract class NullableDynamicInnerGenericTypeShouldBeCastedAsMap {
  @PUT('/')
  Future<GenericUser<User>?> get();
}

@ShouldGenerate('''
    late GenericUser<User?> _value;
    try {
      _value = GenericUser<User?>.fromJson(
        _result.data!,
        (json) =>
            json == null ? null : User.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
''', contains: true)
@RestApi()
abstract class DynamicNullableInnerGenericTypeShouldBeCastedAsMap {
  @PUT('/')
  Future<GenericUser<User?>> get();
}

@ShouldGenerate('''
    late GenericUser<User?>? _value;
    try {
      _value = _result.data == null
          ? null
          : GenericUser<User?>.fromJson(
              _result.data!,
              (json) => json == null
                  ? null
                  : User.fromJson(json as Map<String, dynamic>),
            );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
''', contains: true)
@RestApi()
abstract class NullableDynamicNullableInnerGenericTypeShouldBeCastedAsMap {
  @PUT('/')
  Future<GenericUser<User?>?> get();
}

@ShouldGenerate('''
    late GenericUser<List<double>> _value;
    try {
      _value = GenericUser<List<double>>.fromJson(
        _result.data!,
        (json) => json is List<dynamic>
            ? json.map<double>((i) => i as double).toList()
            : List.empty(),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
''', contains: true)
@RestApi()
abstract class DynamicInnerListGenericPrimitiveTypeShouldBeCastedRecursively {
  @PUT('/')
  Future<GenericUser<List<double>>> get();
}

@ShouldGenerate('''
    late GenericUser<List<double>>? _value;
    try {
      _value = _result.data == null
          ? null
          : GenericUser<List<double>>.fromJson(
              _result.data!,
              (json) => json is List<dynamic>
                  ? json.map<double>((i) => i as double).toList()
                  : List.empty(),
            );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
''', contains: true)
@RestApi()
abstract class NullableDynamicInnerListGenericPrimitiveTypeShouldBeCastedRecursively {
  @PUT('/')
  Future<GenericUser<List<double>>?> get();
}

@ShouldGenerate('''
    late GenericUserWithoutGenericArgumentFactories<dynamic> _value;
    try {
      _value = GenericUserWithoutGenericArgumentFactories<dynamic>.fromJson(
        _result.data!,
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
''', contains: true)
@RestApi()
abstract class DynamicInnerGenericTypeShouldBeWithoutGenericArgumentType {
  @PUT('/')
  Future<GenericUserWithoutGenericArgumentFactories<dynamic>> get();
}

@ShouldGenerate('''
    late GenericUserWithoutGenericArgumentFactories<dynamic>? _value;
    try {
      _value = _result.data == null
          ? null
          : GenericUserWithoutGenericArgumentFactories<dynamic>.fromJson(
              _result.data!,
            );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
''', contains: true)
@RestApi()
abstract class NullableDynamicInnerGenericTypeShouldBeWithoutGenericArgumentType {
  @PUT('/')
  Future<GenericUserWithoutGenericArgumentFactories<dynamic>?> get();
}

@ShouldGenerate('''
    final String? _data = null;
  ''', contains: true)
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

@ShouldGenerate('''
  @override
  Future<void> someGet() async {
''', contains: true)
@RestApi()
abstract class NoMethods with MethodInMixin {}

@ShouldGenerate('await _dio.fetch<Map<String, dynamic>?>', contains: true)
@RestApi()
abstract class NullableGenericCastFetch {
  @GET('/')
  Future<User?> get();
}

@ShouldGenerate('await _dio.fetch<Map<String, dynamic>>', contains: true)
@RestApi()
abstract class GenericCastFetch {
  @GET('/')
  Future<User> get();
}

@ShouldGenerate(
  '''.copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),''',
  contains: true,
)
@RestApi()
abstract class CombineBaseUrls {
  @GET('/')
  Future<User> get();
}

@ShouldGenerate(r'''
    final _headers = <String, dynamic>{
      r'accept':
          'application/x-protobuf; ${Result.getDefault().info_.qualifiedMessageName == "" ? "" : "messageType=${Result.getDefault().info_.qualifiedMessageName}"}',
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = params.writeToBuffer();
    final _options = _setStreamType<Result>(
      Options(
            method: 'GET',
            headers: _headers,
            extra: _extra,
            contentType:
                'application/x-protobuf; ${params.info_.qualifiedMessageName == "" ? "" : "messageType=${params.info_.qualifiedMessageName}"}',
          )
          .compose(
            _dio.options,
            '/',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<List<int>>(_options);
    final _value = await compute(Result.fromBuffer, _result.data!);
''', contains: true)
@RestApi()
abstract class ProtoSupportParserJsonSerializable {
  @GET('/')
  Future<Result> get(@Body() Params params);
}

@ShouldGenerate(r'''
    final _headers = <String, dynamic>{
      r'accept':
          'application/x-protobuf; ${Result.getDefault().info_.qualifiedMessageName == "" ? "" : "messageType=${Result.getDefault().info_.qualifiedMessageName}"}',
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = params.writeToBuffer();
    final _options = _setStreamType<Result>(
      Options(
            method: 'GET',
            headers: _headers,
            extra: _extra,
            contentType:
                'application/x-protobuf; ${params.info_.qualifiedMessageName == "" ? "" : "messageType=${params.info_.qualifiedMessageName}"}',
          )
          .compose(
            _dio.options,
            '/',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<List<int>>(_options);
    final _value = await compute(Result.fromBuffer, _result.data!);
''', contains: true)
@RestApi(parser: Parser.DartJsonMapper)
abstract class ProtoSupportParserDartJsonMapper {
  @GET('/')
  Future<Result> get(@Body() Params params);
}

@ShouldGenerate(r'''
    final _headers = <String, dynamic>{
      r'accept':
          'application/x-protobuf; ${Result.getDefault().info_.qualifiedMessageName == "" ? "" : "messageType=${Result.getDefault().info_.qualifiedMessageName}"}',
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = params.writeToBuffer();
    final _options = _setStreamType<Result>(
      Options(
            method: 'GET',
            headers: _headers,
            extra: _extra,
            contentType:
                'application/x-protobuf; ${params.info_.qualifiedMessageName == "" ? "" : "messageType=${params.info_.qualifiedMessageName}"}',
          )
          .compose(
            _dio.options,
            '/',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<List<int>>(_options);
    final _value = await compute(Result.fromBuffer, _result.data!);
''', contains: true)
@RestApi(parser: Parser.MapSerializable)
abstract class ProtoSupportParserMapSerializable {
  @GET('/')
  Future<Result> get(@Body() Params params);
}

@ShouldGenerate(r'''
    final _headers = <String, dynamic>{
      r'accept':
          'application/x-protobuf; ${Result.getDefault().info_.qualifiedMessageName == "" ? "" : "messageType=${Result.getDefault().info_.qualifiedMessageName}"}',
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = params.writeToBuffer();
    final _options = _setStreamType<Result>(
      Options(
            method: 'GET',
            headers: _headers,
            extra: _extra,
            contentType:
                'application/x-protobuf; ${params.info_.qualifiedMessageName == "" ? "" : "messageType=${params.info_.qualifiedMessageName}"}',
          )
          .compose(
            _dio.options,
            '/',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<List<int>>(_options);
    final _value = await compute(Result.fromBuffer, _result.data!);
''', contains: true)
@RestApi(parser: Parser.FlutterCompute)
abstract class ProtoSupportParserFlutterCompute {
  @GET('/')
  Future<Result> get(@Body() Params params);
}

@ShouldGenerate('''
    final _data = FormData.fromMap(body);
  ''', contains: true)
@RestApi()
abstract class MultipartWithMultiplePathParams {
  @MultiPart()
  @POST('post/{id}/comments/{commentId}')
  Future<String> multipartBodyWithMultiplePathParameter(
    @Path('id') String id,
    @Path('commentId') String commentId,
    @Part() Map<String, dynamic> body,
  );
}

@ShouldGenerate('''
    final _data = FormData.fromMap(body);
  ''', contains: true)
@RestApi()
abstract class MultipartWithSinglePathParams {
  @MultiPart()
  @POST('post/{id}/comments')
  Future<String> multipartBodyWithSinglePathParameter(
    @Path('id') String id,
    @Part() Map<String, dynamic> body,
  );
}

@ShouldGenerate('''
    final _data = FormData.fromMap(body);
  ''', contains: true)
@RestApi()
abstract class MultipartWithMultiplePathParamsPUT {
  @MultiPart()
  @PUT('post/{id}/comments/{commentId}')
  Future<String> multipartBodyWithMultiplePathParameter(
    @Path('id') String id,
    @Path('commentId') String commentId,
    @Part() Map<String, dynamic> body,
  );
}

@ShouldGenerate(
  '''
  @override
  @useResult
  Future<String> someGet() async {
  ''',
  contains: true,
  configurations: ['use_result'],
)
@RestApi()
abstract class UseResult {
  @GET('https://httpbin.org/')
  Future<String> someGet();
}

@ShouldGenerate(
  '''
  @override
  Future<void> someGet() async {
  ''',
  contains: true,
  configurations: ['use_result'],
)
@RestApi()
abstract class UseResultForVoid {
  @GET('https://httpbin.org/')
  Future<void> someGet();
}
