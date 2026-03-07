import 'package:attend/features/auth/domain/entities/auth_entity.dart';
import 'package:attend/features/auth/domain/repositories/auth_repository.dart';
import 'package:attend/features/lecturer/domain/entities/lecturer_entity.dart';

class ContinueWithGoogleUseCase {
  final AuthRepository repository;

  ContinueWithGoogleUseCase({required this.repository});

  Future<(AuthEntity, LecturerEntity)> call() async {
    return await repository.continueWithGoogle();
  }
}
