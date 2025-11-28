import 'package:attend/features/auth/domain/entities/lecturer_entity.dart';
import 'package:attend/features/auth/domain/entities/student_entity.dart';
import 'package:attend/global/error/failures.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> studentSignUp(StudentEntity studentEntity);
  Future<Either<Failure, StudentEntity>> studentLogin(
    String email,
    String password,
  );
  Future<Either<Failure, LecturerEntity>> lecturerSignUp(
    String email,
    String password,
  );
  Future<Either<Failure, LecturerEntity>> lecturerLogin(
    String email,
    String password,
  );
}
