// import 'package:dartz/dartz.dart';
// import 'package:equatable/equatable.dart';
// import 'package:whatsapp_clone/core/error/failures.dart';
// import 'package:whatsapp_clone/core/usecases/usecase.dart';
// import 'package:whatsapp_clone/features/auth/domain/entities/auth_user_entity.dart';
// import 'package:whatsapp_clone/features/auth/domain/repositories/auth_repository.dart';

// class RefreshTokenUseCase
//     implements UseCase<AuthUserEntity, RefreshTokenParams> {
//   final AuthRepository repository;

//   RefreshTokenUseCase(this.repository);

//   @override
//   Future<Either<Failure, AuthUserEntity>> call(
//     RefreshTokenParams params,
//   ) async {
//     return await repository.refreshToken(params.refreshToken);
//   }
// }

// class RefreshTokenParams extends Equatable {
//   final String refreshToken;

//   const RefreshTokenParams(this.refreshToken);

//   @override
//   List<Object?> get props => [refreshToken];
// }
