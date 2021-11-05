import 'package:dio/dio.dart' hide Headers;
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

import 'mock_adapter.dart';

part 'example.g.dart';

User parseUser(Map<String, dynamic> json) => User.fromJson(json);

@JsonSerializable()
class User {
  User({required this.string});

  final String string;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@RestApi(baseUrl: "http://baidu.com", parser: Parser.FlutterCompute)
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET('/tags')
  Future<List<String>> getTags({@DioOptions() Options? options});
  @GET('/tagsNullable')
  Future<List<String>?> getTagsNullable({@DioOptions() Options? options});
  @GET('/tagsOptions')
  Future<Map<String, String>> getTagOptions({@DioOptions() Options? options});
  @GET('/tagsOptionsNullable')
  Future<Map<String, String>?> getTagOptionsNullable(
      {@DioOptions() Options? options});
  @GET('/tags')
  Future<String> getTag({@DioOptions() Options? options});
  @GET('/tagsNullable')
  Future<String?> getTagNullable({@DioOptions() Options? options});

  @GET('/users')
  Future<List<User>> getUsers({@DioOptions() Options? options});
  @GET('/usersNullable')
  Future<List<User>?> getUsersNullable({@DioOptions() Options? options});
  @GET('/userOptions')
  Future<Map<String, User>> getUserOptions({@DioOptions() Options? options});
  @GET('/userOptionsNullable')
  Future<Map<String, User>?> getUserOptionsNullable(
      {@DioOptions() Options? options});
  @GET('/usersOptions')
  Future<Map<String, List<User>>> getUsersOptions(
      {@DioOptions() Options? options});
  @GET('/user')
  Future<User> getUser({@DioOptions() Options? options});
  @GET('/userNullable')
  Future<User?> getUserNullable({@DioOptions() Options? options});

  @POST('/users')
  Future<void> postUsers(
      {@Body() required List<User> users, @DioOptions() Options? options});
  @POST('/usersOptions')
  Future<void> postUsersOptions(
      {@Body() required Map<String, List<User>> users,
      @DioOptions() Options? options});
  @POST('/user')
  Future<void> postUser(
      {@Body() required User users, @DioOptions() Options? options});
  @POST('/userNullable')
  Future<void> postUserNullable(
      {@Body() required User? users, @DioOptions() Options? options});
}

void test() {
  final dio = Dio();
  dio.httpClientAdapter = MockAdapter();

  dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
    print(options.extra);
    print(options.baseUrl);
    print(options.method);
    print(options.headers);
    handler.next(options);
  }));
  final api = RestClient(dio, baseUrl: MockAdapter.mockBase);
  api.getUsers().then((it) {
    print(it.length);
  });
}
