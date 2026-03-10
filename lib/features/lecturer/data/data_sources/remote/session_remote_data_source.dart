import 'package:attend/features/lecturer/domain/entities/session_entity.dart';

abstract class SessionRemoteDataSource {
  Future<void> createSession(SessionEntity sessionEntity);
  Future<SessionEntity> fetchLiveSession(String lecturerId);
  Future<void> endSession(String sessionId);
  Future<int> fetchNumberOfPastSessions(String lecturerId);
  Future<List<SessionEntity>> fetchPastSessions(String lecturerId);
}
