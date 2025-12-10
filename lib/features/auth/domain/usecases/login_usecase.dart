import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:whatsapp_clone/core/error/failures.dart';
import 'package:whatsapp_clone/core/usecases/usecase.dart';
import 'package:whatsapp_clone/features/auth/domain/entities/auth_user_entity.dart';
import 'package:whatsapp_clone/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase implements UseCase<AuthUserEntity, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, AuthUserEntity>> call(LoginParams params) async {
    return await repository.login(
      phoneOrEmail: params.phoneOrEmail,
      password: params.password,
    );
  }
}

class LoginParams extends Equatable {
  final String phoneOrEmail;
  final String password;

  const LoginParams({required this.phoneOrEmail, required this.password});

  @override
  List<Object?> get props => [phoneOrEmail, password];
}
