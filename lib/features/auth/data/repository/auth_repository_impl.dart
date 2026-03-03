import 'package:attend/features/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:attend/features/lecturer/lecturer_entity.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<(AuthEntity, LecturerEntity)> continueWithGoogle() =>
      remoteDataSource.continueWithGoogle();
}
