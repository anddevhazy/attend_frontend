import 'package:attend/features/lecturer/session/domain/entities/session_entity.dart';
import 'package:attend/features/lecturer/session/domain/repositories/session_repository.dart';

class CreateSessionUsecase {
  final SessionRepository repository;

  CreateSessionUsecase({required this.repository});

  Future<void> call(SessionEntity sessionEntity) async {
    await repository.createSession(sessionEntity);
  }
}
