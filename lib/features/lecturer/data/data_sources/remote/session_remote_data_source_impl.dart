import 'package:attend/global/core/network/api_client.dart';
import 'package:attend/global/core/network/api_endpoints.dart';
import 'package:attend/features/lecturer/data/data_sources/remote/session_remote_data_source.dart';
import 'package:attend/features/lecturer/data/models/session_model.dart';
import 'package:attend/features/lecturer/domain/entities/session_entity.dart';

class SessionRemoteDataSourceImpl implements SessionRemoteDataSource {
  final ApiClient client;

  SessionRemoteDataSourceImpl({required this.client});

  @override
  Future<int> fetchNumberOfPastSessions() async {
    final response = await client.getRequest(
      ApiEndpoints.fetchNumberOfPastSessions,
    );

    final data = response.data as Map<String, dynamic>;

    return data['data']['count'] as int;
  }

  @override
  Future<List<SessionEntity>> fetchPastSessions() async {
    final response = await client.getRequest(ApiEndpoints.fetchPastSessions);

    final List data = response.data['data'];

    return data.map((session) => SessionModel.fromJson(session)).toList();
  }

  @override
  Future<String> fetchName() async {
    final response = await client.getRequest(ApiEndpoints.fetchName);
    print('STATUS CODE: ${response.statusCode}');
    print('RESPONSE DATA: ${response.data}');

    return response.data['user']['name'] as String;
  }

  @override
  Future<void> createSession(SessionEntity sessionEntity) async {
    await client.postRequest(
      ApiEndpoints.createSession,
      data: {
        "courseId": sessionEntity.course.courseId,
        "locationId": sessionEntity.location.locationId,
      },
    );
  }

  @override
  Future<void> endSession(String sessionId) async {
    final response = await client.patchRequest(
      ApiEndpoints.endSession(sessionId),
    );
    print('STATUS CODE: ${response.statusCode}');
    print('RESPONSE DATA: ${response.data}');
  }

  @override
  Future<SessionEntity> fetchLiveSession() async {
    final response = await client.getRequest(ApiEndpoints.fetchLiveSession);
    print('STATUS CODE: ${response.statusCode}');
    print('RESPONSE DATA: ${response.data}');

    final liveSession = SessionModel.fromJson(response.data['data']);
    print('PARSED SESSION: $liveSession');
    return liveSession;
  }
}
