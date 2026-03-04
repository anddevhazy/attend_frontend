import 'package:attend/features/auth/data/data_sources/local/auth_local_data_source.dart';
import 'package:attend/features/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:attend/features/lecturer/lecturer_entity.dart';
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

    await localDataSource.saveToken(auth.token);

    return result;
  }

  @override
  Future<void> logout() async {
    await localDataSource.logout();
  }
}
