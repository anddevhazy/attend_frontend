import 'package:attend/features/auth/domain/entities/auth_entity.dart';
import 'package:attend/features/lecturer/domain/entities/lecturer_entity.dart';

abstract class AuthRepository {
  Future<(AuthEntity, LecturerEntity)> continueWithGoogle();
  Future<void> logout();
}
