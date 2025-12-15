import 'package:attend/core/error/failures.dart';
import 'package:attend/core/network/api_client.dart';
import 'package:attend/core/network/api_endpoints.dart';
import 'package:attend/features/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:attend/features/auth/data/models/student_model.dart';
import 'package:attend/features/auth/domain/entities/student_entity.dart';
import 'package:attend/storage/token_storage_provider.dart';
import 'package:dartz/dartz.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient client;
  final TokenStorageProvider tokenStorage;

  AuthRemoteDataSourceImpl({required this.client, required this.tokenStorage});

  @override
  Future<Either<Failure, StudentEntity>> studentSignUp(
    StudentEntity studentEntity,
  ) async {
    try {
      final response = await client.postRequest<Map<String, dynamic>>(
        ApiEndpoints.studentSignup,
        data: {
          'studentId': studentEntity.studentId,
          'email': studentEntity.email,
          'password': studentEntity.password,
        },
      );
      if (response.data == null) {
        return Left(ServerFailure('Empty server response'));
      }
      final data = response.data!;
      final student = StudentModel.fromJson(
        data['user'] as Map<String, dynamic>,
      );
      final accessToken = data['accessToken'] as String;
      final refreshToken = data['refreshToken'] as String?;
      await tokenStorage.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
      return Right(student);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  // @override
  // Future<UserModel> login({
  //   required String email,
  //   required String password,
  // }) async {
  //   final response = await _client.postRequest<Map<String, dynamic>>(
  //     ApiEndpoints.login,
  //     data: {'email': email, 'password': password},
  //   );
  //   final data = response.data!;
  //   final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
  //   final accessToken = data['accessToken'] as String;
  //   final refreshToken = data['refreshToken'] as String?;
  //   await _tokenStorage.saveTokens(
  //     accessToken: accessToken,
  //     refreshToken: refreshToken,
  //   );
  //   return user;
  // }

  // @override
  // Future<void> logout() async {
  //   await _client.postRequest<void>(ApiEndpoints.logout);
  //   await _tokenStorage.clearTokens();
  // }
}
