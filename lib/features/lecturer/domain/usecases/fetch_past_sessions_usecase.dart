import 'package:attend/features/lecturer/domain/entities/session_entity.dart';
import 'package:attend/features/lecturer/domain/repositories/session_repository.dart';

class FetchPastSessionsUsecase {
  final SessionRepository repository;

  FetchPastSessionsUsecase({required this.repository});

  Future<List<SessionEntity>> call() async {
    return await repository.fetchPastSessions();
  }
}
