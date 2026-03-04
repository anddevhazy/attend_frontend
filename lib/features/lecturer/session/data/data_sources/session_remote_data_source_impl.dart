import 'package:attend/core/network/api_client.dart';
import 'package:attend/core/network/api_endpoints.dart';
import 'package:attend/features/lecturer/lecturer_entity.dart';
import 'package:attend/features/lecturer/session/data/data_sources/session_remote_data_source.dart';
import 'package:attend/features/lecturer/session/domain/entities/session_entity.dart';
import 'package:dio/dio.dart';

class SessionRemoteDataSourceImpl implements SessionRemoteDataSource {
  final ApiClient client;

  SessionRemoteDataSourceImpl({required this.client});

  @override
  Future<void> createSession(SessionEntity sessionEntity) async {
    await client.postRequest(
      ApiEndpoints.createSession,
      data: {
        'courseId': sessionEntity.courseId.courseId,
        'locationId': sessionEntity.locationId.locationId,
      },
      options: Options(headers: {"Authorization": "Bearer YOUR_JWT_TOKEN"}),
    );
  }

  @override
  Future<void> endSession(SessionEntity sessionId) {
    throw UnimplementedError();
  }

  @override
  Future<SessionEntity> fetchLiveSession(LecturerEntity lecturerId) {
    throw UnimplementedError();
  }

  @override
  Future<int> fetchNumberOfPastSessions(LecturerEntity lecturerId) {
    throw UnimplementedError();
  }

  @override
  Future<List<SessionEntity>> fetchPastSessions(LecturerEntity lecturerId) {
    throw UnimplementedError();
  }
}
