import 'package:attend/features/lecturer/data/data_sources/remote/session_remote_data_source.dart';
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
  Future<SessionEntity> fetchLiveSession() async =>
      remoteDataSource.fetchLiveSession();

  @override
  Future<int> fetchNumberOfPastSessions() async =>
      remoteDataSource.fetchNumberOfPastSessions();

  @override
  Future<List<SessionEntity>> fetchPastSessions() async =>
      remoteDataSource.fetchPastSessions();

  @override
  Future<String> fetchName() async => remoteDataSource.fetchName();
}
