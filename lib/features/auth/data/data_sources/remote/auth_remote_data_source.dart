import 'package:attend/features/auth/domain/entities/auth_entity.dart';
import 'package:attend/features/lecturer/lecturer_entity.dart';

abstract class AuthRemoteDataSource {
  Future<(AuthEntity, LecturerEntity)> continueWithGoogle();
}
