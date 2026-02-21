import 'package:attend/core/error/failures.dart';
import 'package:attend/core/network/api_client.dart';
import 'package:attend/core/network/api_endpoints.dart';
import 'package:attend/core/network/api_exceptions.dart';
import 'package:attend/features/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:dartz/dartz.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<Either<Failure, Map<String, dynamic>>> studentSignUp(
    String email,
    String password,
  ) async {
    try {
      final response = await client.postRequest(
        ApiEndpoints.studentSignup,
        data: {'email': email, 'password': password},
      );
      return Right({
        'id': response.data['data']['id'],
        'email': response.data['data']['email'],
        'emailSent': response.data['message'].toLowerCase().contains(
          'verification email sent',
        ),
      });
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
