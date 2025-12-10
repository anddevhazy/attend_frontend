import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:whatsapp_clone/core/error/failures.dart';
import 'package:whatsapp_clone/core/usecases/usecase.dart';
import 'package:whatsapp_clone/features/user/domain/entities/user_entity.dart';
import 'package:whatsapp_clone/features/user/domain/repositories/user_repository.dart';

class SearchUsersUseCase implements UseCase<List<UserEntity>, SearchParams> {
  final UserRepository repository;
  SearchUsersUseCase(this.repository);

  @override
  Future<Either<Failure, List<UserEntity>>> call(SearchParams params) =>
      repository.searchUsers(params.query);
}

class SearchParams extends Equatable {
  final String query;
  const SearchParams(this.query);
  @override
  List<Object?> get props => [query];
}
