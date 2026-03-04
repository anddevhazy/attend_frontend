import 'package:attend/core/network/api_client.dart';
import 'package:attend/core/network/api_endpoints.dart';
import 'package:attend/features/lecturer/session/data/data_sources/session_remote_data_source.dart';
import 'package:attend/features/lecturer/session/data/models/session_model.dart';
import 'package:attend/features/lecturer/session/domain/entities/session_entity.dart';

class SessionRemoteDataSourceImpl implements SessionRemoteDataSource {
  final ApiClient client;

  SessionRemoteDataSourceImpl({required this.client});

  @override
  Future<void> createSession(SessionEntity sessionEntity) async {
    await client.postRequest(
      ApiEndpoints.createSession,
      data: {
        "courseId": sessionEntity.courseId.courseId,
        "locationId": sessionEntity.locationId.locationId,
      },
    );
  }

  @override
  Future<void> endSession(String sessionId) async {
    await client.postRequest(ApiEndpoints.endSession(sessionId));
  }

  @override
  Future<SessionEntity> fetchLiveSession(String lecturerId) async {
    final response = await client.getRequest<Map<String, dynamic>>(
      ApiEndpoints.fetchLiveSession,
    );

    final json = response.data?['data'] as Map<String, dynamic>;
    return SessionModel.fromJson(json);
  }

  @override
  Future<int> fetchNumberOfPastSessions(String lecturerId) async {
    final response = await client.getRequest(
      ApiEndpoints.fetchNumberOfPastSessions,
    );

    final data = response.data as Map<String, dynamic>;

    return data['data']['count'] as int;
  }

  @override
  Future<List<SessionEntity>> fetchPastSessions(String lecturerId) async {
    final response = await client.getRequest(ApiEndpoints.fetchPastSessions);

    final List data = response.data['data'];

    return data.map((session) => SessionModel.fromJson(session)).toList();
  }
}
