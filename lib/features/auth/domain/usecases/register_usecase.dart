import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:whatsapp_clone/core/error/failures.dart';
import 'package:whatsapp_clone/core/usecases/usecase.dart';
import 'package:whatsapp_clone/features/auth/domain/entities/auth_user_entity.dart';
import 'package:whatsapp_clone/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase implements UseCase<AuthUserEntity, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, AuthUserEntity>> call(RegisterParams params) async {
    return await repository.register(
      name: params.name,
      phoneNumber: params.phoneNumber,
      password: params.password,
    );
  }
}

class RegisterParams extends Equatable {
  final String name;
  final String phoneNumber;
  final String password;

  const RegisterParams({
    required this.name,
    required this.phoneNumber,
    required this.password,
  });

  @override
  List<Object?> get props => [name, phoneNumber, password];
}
