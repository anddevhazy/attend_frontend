import 'package:attend/core/error/failures.dart';
import 'package:attend/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class StudentSignUpUsecase {
  final AuthRepository repository;

  StudentSignUpUsecase({required this.repository});

  Future<Either<Failure, Map<String, dynamic>>> call(
    String email,
    String password,
  ) async {
    return await repository.studentSignUp(email, password);
  }
}
