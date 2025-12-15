import 'package:attend/core/error/failures.dart';
import 'package:attend/features/auth/domain/entities/student_entity.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRemoteDataSource {
  // Future<Either<Failure, AuthUserEntity>> login({
  //   required String phoneOrEmail,
  //   required String password,
  // });
  Future<Either<Failure, StudentEntity>> studentSignUp(
    StudentEntity studentEntity,
  );

  // Future<Either<Failure, Unit>> logout();

  // Future<Either<Failure, AuthStudentEntity>> refreshToken(String refreshToken);
}
