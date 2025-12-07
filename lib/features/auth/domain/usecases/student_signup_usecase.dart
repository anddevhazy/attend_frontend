import 'package:attend/core/error/failures.dart';
import 'package:attend/features/auth/domain/entities/student_entity.dart';
import 'package:attend/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class StudentSignupUsecase {
  final AuthRepository repository;

  StudentSignupUsecase({required this.repository});

  Future<Either<Failure, Unit>> call(StudentEntity studentEntity) async {
    return await repository.studentSignUp(studentEntity);
  }
}
