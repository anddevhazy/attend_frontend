import 'package:attend/core/error/failures.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, Map<String, dynamic>>> studentSignUp(
    String email,
    String password,
  );
}
