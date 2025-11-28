import 'package:attend/features/auth/domain/entities/student_entity.dart';
import 'package:attend/features/auth/domain/repositories/auth_repository.dart';
import 'package:attend/global/error/failures.dart';
import 'package:dartz/dartz.dart';

class StudentSignupUsecase {
  final AuthRepository repository;

  StudentSignupUsecase({required this.repository});

  Future<Either<Failure, void>> call(StudentEntity studentEntity) async {
    return await repository.studentSignUp(studentEntity);
  }
}
