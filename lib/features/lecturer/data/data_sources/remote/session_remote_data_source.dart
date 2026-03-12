import 'package:attend/features/lecturer/domain/entities/session_entity.dart';

abstract class SessionRemoteDataSource {
  Future<void> createSession(SessionEntity sessionEntity);
  Future<SessionEntity?> fetchLiveSession();
  Future<void> endSession(String sessionId);
  Future<int> fetchNumberOfPastSessions();
  Future<List<SessionEntity>> fetchPastSessions();
  Future<String> fetchName();
}
