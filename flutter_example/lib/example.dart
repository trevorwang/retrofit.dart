import 'package:dio/dio.dart' hide Headers;
import 'package:flutter/foundation.dart';
import 'package:flutter_example/mock_adapter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

part 'example.g.dart';

User deserializeUser(Map<String, dynamic> json) => User.fromJson(json);

List<User> deserializeUserList(List<Map<String, dynamic>> json) =>
    json.map(User.fromJson).toList();

Map<String, dynamic> serializeUser(User object) => object.toJson();

List<Map<String, dynamic>> serializeUserList(List<User> objects) =>
    objects.map((e) => e.toJson()).toList();

@JsonSerializable()
class User {
  const User({required this.id});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  final String id;

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@RestApi(baseUrl: 'http://baidu.com', parser: Parser.FlutterCompute)
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET('/tags')
  Future<List<String>> getTags({@DioOptions() Options? options});

  @GET('/tagsNullable')
  Future<List<String>?> getTagsNullable({@DioOptions() Options? options});

  @GET('/tagByKey')
  Future<Map<String, String>> getTagByKey({@DioOptions() Options? options});

  @GET('/tagByKeyNullable')
  Future<Map<String, String>?> getTagByKeyNullable({
    @DioOptions() Options? options,
  });

  @GET('/tag')
  Future<String> getTag({
    @DioOptions() Options? options,
    @Header('Content-Type') String contentType,
  });

  @GET('/tagNullable')
  Future<String?> getTagNullable({@DioOptions() Options? options});

  @GET('/users')
  Future<List<User>> getUsers({@DioOptions() Options? options});

  @GET('/usersNullable')
  Future<List<User>?> getUsersNullable({@DioOptions() Options? options});

  @GET('/userByKey')
  Future<Map<String, User>> getUserByKey({@DioOptions() Options? options});

  @GET('/userByKeyNullable')
  Future<Map<String, User>?> getUserByKeyNullable({
    @DioOptions() Options? options,
  });

  @GET('/usersByKey')
  Future<Map<String, List<User>>> getUsersByKey({
    @DioOptions() Options? options,
  });

  @GET('/user')
  Future<User> getUser({@DioOptions() Options? options});

  @GET('/userNullable')
  Future<User?> getUserNullable({@DioOptions() Options? options});

  @PATCH('/user/{user}')
  Future<void> patchUser({
    @Query('u') required User user,
    @DioOptions() Options? options,
  });

  @PATCH('/userMap/{user}')
  Future<void> patchUserMap({
    @Queries() required User user,
    @DioOptions() Options? options,
  });

  @POST('/users')
  Future<void> postUsers({
    @Body() required List<User> users,
    @DioOptions() Options? options,
  });

  @POST('/user')
  Future<void> postUser({
    @Body() required User user,
    @DioOptions() Options? options,
  });

  @POST('/userNullable')
  Future<void> postUserNullable({
    @Body() required User? user,
    @DioOptions() Options? options,
  });
}

void test() {
  final dio = Dio();
  dio.httpClientAdapter = MockAdapter();

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        print(options.extra);
        print(options.baseUrl);
        print(options.method);
        print(options.headers);
        handler.next(options);
      },
    ),
  );
  final api = RestClient(dio, baseUrl: MockAdapter.mockBase);
  api.getUsers().then((it) {
    print(it.length);
  });
}
