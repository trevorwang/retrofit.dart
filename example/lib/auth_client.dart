import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_client.g.dart';

@RestApi()
abstract class AuthClient {
  factory AuthClient(
    Dio dio, {
    String? baseUrl,
    ParseErrorLogger? errorLogger,
  }) = RestClientYmlp;

  @POST('/api/auth/mqttClient/authentication')
  Future<Object?> authenticationUsingPost({
    @Body() required RegisterModel submitModel,
  });
}

class RegisterModel {
  const RegisterModel({
    this.channel,
    this.mobile,
    this.verfiyCode,
  });

  factory RegisterModel.fromJson(Map<String, Object?> json) => RegisterModel(
        channel: json['channel'] as String?,
        mobile: json['mobile'] as String?,
        verfiyCode: json['verfiyCode'] as String?,
      );

  final String? channel;
  final String? mobile;
  final String? verfiyCode;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'channel': channel,
        'mobile': mobile,
        'verfiyCode': verfiyCode,
      };
}
