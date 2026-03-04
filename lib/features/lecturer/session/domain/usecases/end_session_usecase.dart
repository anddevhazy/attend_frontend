import 'package:attend/features/lecturer/session/domain/entities/session_entity.dart';
import 'package:attend/features/lecturer/session/domain/repositories/session_repository.dart';

class EndSessionUsecase {
  final SessionRepository repository;

  EndSessionUsecase({required this.repository});

  Future<void> call(SessionEntity sessionEntity) async {
    await repository.endSession(sessionEntity);
  }
}
