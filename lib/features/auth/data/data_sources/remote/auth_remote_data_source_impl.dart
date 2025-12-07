import 'dart:async';

import 'package:whatsapp_clone_app/core/network/api_client.dart';
import 'package:whatsapp_clone_app/core/network/api_endpoints.dart';
import 'package:whatsapp_clone_app/features/call/data/models/call_model.dart';
import 'package:whatsapp_clone_app/features/call/data/remote/call_remote_data_source.dart';
import 'package:whatsapp_clone_app/features/call/domain/entities/call_entity.dart';

class CallRemoteDataSourceImpl implements CallRemoteDataSource {
  final ApiClient _client;

  CallRemoteDataSourceImpl({required ApiClient client}) : _client = client;

  @override
  Future<void> makeCall(CallEntity call) async {
    final model = _fromEntity(
      call,
      // For a fresh call:
      isCallDialed: true,
      isMissed: false,
      createdAt: DateTime.now(),
    );

    await _client.postRequest<void>(ApiEndpoints.calls, data: model.toJson());
  }

  @override
  Future<void> endCall(CallEntity call) async {
    if (call.callId == null || call.callId!.isEmpty) {
      // you might throw a custom exception here.
      return;
    }

    await _client.postRequest<void>(
      '${ApiEndpoints.callById(call.callId!)}${'/end'}',
    );
  }

  @override
  Future<String> getCallChannelId(String uid) async {
    final response = await _client.getRequest<Map<String, dynamic>>(
      ApiEndpoints.callChannel,
      queryParameters: {'userId': uid},
    );

    final data = response.data ?? {};
    return data['callId'] as String? ?? '';
  }

  @override
  Stream<List<CallEntity>> getMyCallHistory(String uid) {
    return Stream.fromFuture(_getMyCallHistoryOnce(uid));
  }

  Future<List<CallEntity>> _getMyCallHistoryOnce(String uid) async {
    final response = await _client.getRequest<List<dynamic>>(
      ApiEndpoints.myCallHistory,
    );

    final list = response.data ?? [];
    return list
        .map((e) => CallModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Stream<List<CallEntity>> getUserCalling(String uid) {
    return Stream.fromFuture(_getUserCallingOnce(uid));
  }

  Future<List<CallEntity>> _getUserCallingOnce(String uid) async {
    final response = await _client.getRequest<List<dynamic>>(
      ApiEndpoints.ongoingCalls,
      queryParameters: {'userId': uid},
    );

    final list = response.data ?? [];
    return list
        .map((e) => CallModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveCallHistory(CallEntity call) async {
    if (call.callId == null || call.callId!.isEmpty) {}

    final model = _fromEntity(
      call,
      createdAt: call.createdAt ?? DateTime.now(),
    );

    await _client.postRequest<void>(
      ApiEndpoints.callHistory(call.callId),
      data: model.toJson(),
    );
  }

  @override
  Future<void> updateCallHistoryStatus(CallEntity call) async {
    if (call.callId == null || call.callId!.isEmpty) {
      return;
    }

    final Map<String, dynamic> historyInfo = {};

    if (call.isCallDialed != null) {
      historyInfo['isCallDialed'] = call.isCallDialed;
    }
    if (call.isMissed != null) {
      historyInfo['isMissed'] = call.isMissed;
    }

    if (historyInfo.isEmpty) {
      return;
    }

    await _client.putRequest<void>(
      ApiEndpoints.callHistory(call.callId),
      data: historyInfo,
    );
  }

  /// Helper to convert a domain CallEntity into a CallModel for JSON.
  CallModel _fromEntity(
    CallEntity call, {
    bool? isCallDialed,
    bool? isMissed,
    DateTime? createdAt,
  }) {
    return CallModel(
      callId: call.callId,
      callerId: call.callerId,
      callerName: call.callerName,
      callerProfileUrl: call.callerProfileUrl,
      receiverId: call.receiverId,
      receiverName: call.receiverName,
      receiverProfileUrl: call.receiverProfileUrl,
      isCallDialed: isCallDialed ?? call.isCallDialed,
      isMissed: isMissed ?? call.isMissed,
      createdAt: createdAt ?? call.createdAt,
    );
  }
}
