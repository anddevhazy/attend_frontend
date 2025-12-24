import 'package:attend/core/error/failures.dart';
import 'package:attend/features/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:attend/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Map<String, dynamic>>> studentSignUp(
    String email,
    String password,
  ) async => remoteDataSource.studentSignUp(email, password);
}
