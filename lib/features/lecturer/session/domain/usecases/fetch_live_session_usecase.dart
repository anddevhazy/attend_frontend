import 'package:attend/features/lecturer/lecturer_entity.dart';
import 'package:attend/features/lecturer/session/domain/entities/session_entity.dart';
import 'package:attend/features/lecturer/session/domain/repositories/session_repository.dart';

class FetchLiveSessionUsecase {
  final SessionRepository repository;

  FetchLiveSessionUsecase({required this.repository});

  Future<SessionEntity> call(LecturerEntity lecturerId) async {
    return await repository.fetchLiveSession(lecturerId);
  }
}
