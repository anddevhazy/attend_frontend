import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:whatsapp_clone/features/auth/data/models/auth_response_model.dart';

part 'auth_remote_data_source.g.dart';

@RestApi()
abstract class AuthRemoteDataSource {
  factory AuthRemoteDataSource(Dio dio, {String baseUrl}) =
      _AuthRemoteDataSource;

  @POST('/auth/login')
  Future<AuthResponseModel> login({@Body() required Map<String, dynamic> body});

  @POST('/auth/register')
  Future<AuthResponseModel> register({
    @Body() required Map<String, dynamic> body,
  });

  @POST('/auth/auth/refresh-token')
  Future<AuthResponseModel> refreshToken({
    @Field('refreshToken') required String refreshToken,
  });

  @POST('/auth/logout')
  Future<void> logout();
}
