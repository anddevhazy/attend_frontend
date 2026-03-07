import 'package:attend/features/lecturer/domain/entities/session_entity.dart';
import 'package:attend/features/lecturer/domain/repositories/session_repository.dart';

class CreateSessionUsecase {
  final SessionRepository repository;

  CreateSessionUsecase({required this.repository});

  Future<void> call(SessionEntity sessionEntity) async {
    await repository.createSession(sessionEntity);
  }
}
