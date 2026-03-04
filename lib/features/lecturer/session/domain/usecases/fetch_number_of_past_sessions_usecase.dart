import 'package:attend/features/lecturer/session/domain/repositories/session_repository.dart';

class FetchNumberOfPastSessionsUsecase {
  final SessionRepository repository;

  FetchNumberOfPastSessionsUsecase({required this.repository});

  Future<int> call(String lecturerId) async {
    return await repository.fetchNumberOfPastSessions(lecturerId);
  }
}
