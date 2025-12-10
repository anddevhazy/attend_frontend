import 'package:dartz/dartz.dart';
import 'package:whatsapp_clone/core/error/failures.dart';
import 'package:whatsapp_clone/features/auth/domain/entities/auth_user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthUserEntity>> login({
    required String phoneOrEmail,
    required String password,
  });

  Future<Either<Failure, AuthUserEntity>> register({
    required String name,
    required String phoneNumber,
    required String password,
  });

  Future<Either<Failure, Unit>> logout();

  Future<Either<Failure, AuthUserEntity>> refreshToken(String refreshToken);
}
