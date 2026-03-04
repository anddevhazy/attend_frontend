import 'package:attend/features/lecturer/lecturer_entity.dart';
import 'package:attend/features/lecturer/session/domain/repositories/session_repository.dart';

class FetchNumberOfPastSessionsUsecase {
  final SessionRepository repository;

  FetchNumberOfPastSessionsUsecase({required this.repository});

  Future<int> call(LecturerEntity lecturerId) async {
    return await repository.fetchNumberOfPastSessions(lecturerId);
  }
}
