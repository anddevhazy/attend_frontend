import 'package:attend/features/lecturer/lecturer_entity.dart';
import 'package:attend/features/lecturer/session/domain/entities/session_entity.dart';

abstract class SessionRepository {
  Future<void> createSession(SessionEntity sessionEntity);
  Future<SessionEntity> fetchLiveSession(LecturerEntity lecturerId);
  Future<void> endSession(SessionEntity sessionId);
  Future<int> fetchNumberOfPastSessions(LecturerEntity lecturerId);
  Future<List<SessionEntity>> fetchPastSessions(LecturerEntity lecturerId);
}
