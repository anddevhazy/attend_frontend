import 'package:attend/features/auth/data/data_sources/local/auth_local_data_source.dart';
import 'package:attend/features/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:attend/features/lecturer/domain/entities/lecturer_entity.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<(AuthEntity, LecturerEntity)> continueWithGoogle() async {
    final result = await remoteDataSource.continueWithGoogle();

    final auth = result.$1;

    await localDataSource.saveAccessToken(auth.accessToken);
    await localDataSource.saveRefreshToken(auth.refreshToken);
    return result;
  }

  @override
  Future<void> logout() async {
    final refreshToken = await localDataSource.getRefreshToken();

    if (refreshToken != null) {
      try {
        await remoteDataSource.logout(refreshToken);
      } catch (_) {
        // Handle logout failure, e.g., log the error or ignore it
      }
      await localDataSource.logout();
    }
  }
}
