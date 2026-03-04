// import 'package:dartz/dartz.dart';
// import 'package:whatsapp_clone/core/error/exceptions.dart';
// import 'package:whatsapp_clone/core/error/failures.dart';
// import 'package:whatsapp_clone/core/network/network_info.dart';
// import 'package:whatsapp_clone/features/user/domain/entities/user_entity.dart';
// import 'package:whatsapp_clone/features/user/domain/repositories/user_repository.dart';
// import 'package:whatsapp_clone/features/user/data/datasources/user_remote_data_source.dart';
// import 'package:whatsapp_clone/features/user/data/models/user_model.dart';

// class UserRepositoryImpl implements UserRepository {
//   final UserRemoteDataSource remoteDataSource;
//   final NetworkInfo networkInfo;

//   UserRepositoryImpl({
//     required this.remoteDataSource,
//     required this.networkInfo,
//   });

//   @override
//   Future<Either<Failure, List<UserEntity>>> getAllUsers() async {
//     if (!await networkInfo.isConnected) return Left(NetworkFailure());

//     try {
//       final models = await remoteDataSource.getAllUsers();
//       return Right(models.map((m) => m.toEntity()).toList());
//     } on ServerException catch (e) {
//       return Left(ServerFailure(e.message));
//     } catch (_) {
//       return Left(ServerFailure('Failed to load users'));
//     }
//   }

//   @override
//   Future<Either<Failure, UserEntity>> getCurrentUser() async {
//     if (!await networkInfo.isConnected) return Left(NetworkFailure());

//     try {
//       final model = await remoteDataSource.getCurrentUser();
//       return Right(model.toEntity());
//     } on ServerException catch (e) {
//       return Left(ServerFailure(e.message));
//     } catch (_) {
//       return Left(ServerFailure('Failed to load current user'));
//     }
//   }

//   @override
//   Future<Either<Failure, UserEntity>> getUserById(String uid) async {
//     if (!await networkInfo.isConnected) return Left(NetworkFailure());

//     try {
//       final model = await remoteDataSource.getUserById(uid);
//       return Right(model.toEntity());
//     } on ServerException catch (e) {
//       return Left(ServerFailure(e.message));
//     } catch (_) {
//       return Left(NotFoundFailure('User not found'));
//     }
//   }

//   @override
//   Future<Either<Failure, List<UserEntity>>> searchUsers(String query) async {
//     if (!await networkInfo.isConnected) return Left(NetworkFailure());

//     try {
//       final models = await remoteDataSource.searchUsers(query);
//       return Right(models.map((m) => m.toEntity()).toList());
//     } on ServerException catch (e) {
//       return Left(ServerFailure(e.message));
//     } catch (_) {
//       return Left(ServerFailure('Search failed'));
//     }
//   }

//   @override
//   Future<Either<Failure, UserEntity>> updateUser(UserEntity user) async {
//     if (!await networkInfo.isConnected) return Left(NetworkFailure());

//     try {
//       final model = await remoteDataSource.updateUser({
//         if (user.name.isNotEmpty) 'name': user.name,
//         if (user.photoUrl != null) 'photoUrl': user.photoUrl,
//         if (user.status != null) 'status': user.status,
//       });
//       return Right(model.toEntity());
//     } on ServerException catch (e) {
//       return Left(ServerFailure(e.message));
//     } catch (_) {
//       return Left(ServerFailure('Update failed'));
//     }
//   }

//   @override
//   Future<Either<Failure, Unit>> updatePresence(bool isOnline) async {
//     try {
//       await remoteDataSource.updatePresence(
//         UserPresenceModel(isOnline: isOnline, lastSeen: DateTime.now()),
//       );
//       return const Right(unit);
//     } catch (_) {
//       // Presence is best-effort — don't fail the app if it errors
//       return const Right(unit);
//     }
//   }
// }
