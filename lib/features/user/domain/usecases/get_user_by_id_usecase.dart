import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:whatsapp_clone/core/error/failures.dart';
import 'package:whatsapp_clone/core/usecases/usecase.dart';
import 'package:whatsapp_clone/features/user/domain/entities/user_entity.dart';
import 'package:whatsapp_clone/features/user/domain/repositories/user_repository.dart';

class GetUserByIdUseCase implements UseCase<UserEntity, UserIdParams> {
  final UserRepository repository;
  GetUserByIdUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(UserIdParams params) =>
      repository.getUserById(params.uid);
}

class UserIdParams extends Equatable {
  final String uid;
  const UserIdParams(this.uid);
  @override
  List<Object?> get props => [uid];
}
