import 'package:attend/features/lecturer/data/data_sources/session_remote_data_source.dart';
import 'package:attend/features/lecturer/domain/entities/session_entity.dart';
import 'package:attend/features/lecturer/domain/repositories/session_repository.dart';

class SessionRepositoryImpl implements SessionRepository {
  final SessionRemoteDataSource remoteDataSource;

  SessionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createSession(SessionEntity sessionEntity) async =>
      remoteDataSource.createSession(sessionEntity);

  @override
  Future<void> endSession(String sessionId) async =>
      remoteDataSource.endSession(sessionId);

  @override
  Future<SessionEntity> fetchLiveSession(String lecturerId) async =>
      remoteDataSource.fetchLiveSession(lecturerId);

  @override
  Future<int> fetchNumberOfPastSessions(String lecturerId) async =>
      remoteDataSource.fetchNumberOfPastSessions(lecturerId);

  @override
  Future<List<SessionEntity>> fetchPastSessions(String lecturerId) async =>
      remoteDataSource.fetchPastSessions(lecturerId);
}
