import 'package:attend/features/lecturer/session/domain/repositories/session_repository.dart';

class EndSessionUsecase {
  final SessionRepository repository;

  EndSessionUsecase({required this.repository});

  Future<void> call(String sessionId) async {
    await repository.endSession(sessionId);
  }
}
