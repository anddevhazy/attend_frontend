import 'package:dartz/dartz.dart';
import 'package:whatsapp_clone/core/error/exceptions.dart';
import 'package:whatsapp_clone/core/error/failures.dart';
import 'package:whatsapp_clone/core/network/network_info.dart';
import 'package:whatsapp_clone/features/auth/domain/entities/auth_user_entity.dart';
import 'package:whatsapp_clone/features/auth/domain/repositories/auth_repository.dart';
import 'package:whatsapp_clone/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:whatsapp_clone/features/auth/data/models/auth_response_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, AuthUserEntity>> login({
    required String phoneOrEmail,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.login(
        body: {'identifier': phoneOrEmail, 'password': password},
      );
      // Save tokens securely (e.g., flutter_secure_storage)
      await _saveTokens(response.accessToken, response.refreshToken);
      return Right(response.user.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException {
      return Left(UnauthorizedFailure());
    } catch (_) {
      return Left(ServerFailure('Login failed'));
    }
  }

  @override
  Future<Either<Failure, AuthUserEntity>> register({
    required String name,
    required String phoneNumber,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) return Left(NetworkFailure());

    try {
      final response = await remoteDataSource.register(
        body: {'name': name, 'phoneNumber': phoneNumber, 'password': password},
      );
      await _saveTokens(response.accessToken, response.refreshToken);
      return Right(response.user.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Registration failed'));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await remoteDataSource.logout();
      await _clearTokens();
      return const Right(unit);
    } catch (_) {
      return const Right(unit); // Logout locally even if server fails
    }
  }

  @override
  Future<Either<Failure, AuthUserEntity>> refreshToken(
    String refreshToken,
  ) async {
    try {
      final response = await remoteDataSource.refreshToken(
        refreshToken: refreshToken,
      );
      await _saveTokens(response.accessToken, response.refreshToken);
      return Right(response.user.toEntity());
    } on UnauthorizedException {
      await _clearTokens();
      return Left(UnauthorizedFailure());
    } catch (_) {
      return Left(ServerFailure('Token refresh failed'));
    }
  }

  // Helper methods (use flutter_secure_storage in real app)
  Future<void> _saveTokens(String access, String refresh) async {
    // TODO: Save using flutter_secure_storage
  }

  Future<void> _clearTokens() async {
    // TODO: Clear tokens
  }
}
