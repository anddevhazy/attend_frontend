import 'package:whatsapp_clone_app/features/call/domain/entities/call_entity.dart';

class CallModel extends CallEntity {
  final String? callId;
  final String? callerId;
  final String? callerName;
  final String? callerProfileUrl;

  final String? receiverId;
  final String? receiverName;
  final String? receiverProfileUrl;
  final bool? isCallDialed;
  final bool? isMissed;
  final DateTime? createdAt; // <— changed from Timestamp

  CallModel({
    this.callId,
    this.callerId,
    this.callerName,
    this.callerProfileUrl,
    this.receiverId,
    this.receiverName,
    this.receiverProfileUrl,
    this.isCallDialed,
    this.isMissed,
    this.createdAt,
  }) : super(
         callerId: callerId,
         callerName: callerName,
         callerProfileUrl: callerProfileUrl,
         callId: callId,
         isCallDialed: isCallDialed,
         receiverId: receiverId,
         receiverName: receiverName,
         receiverProfileUrl: receiverProfileUrl,
         isMissed: isMissed,
         createdAt: createdAt,
       );

  /// This replaces `fromSnapshot(DocumentSnapshot snapshot)`
  factory CallModel.fromJson(Map<String, dynamic> json) {
    return CallModel(
      callId: json['callId'] as String?,
      callerId: json['callerId'] as String?,
      callerName: json['callerName'] as String?,
      callerProfileUrl: json['callerProfileUrl'] as String?,
      receiverId: json['receiverId'] as String?,
      receiverName: json['receiverName'] as String?,
      receiverProfileUrl: json['receiverProfileUrl'] as String?,
      isCallDialed: json['isCallDialed'] as bool?,
      isMissed: json['isMissed'] as bool?,
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : null,
    );
  }

  /// This replaces `toDocument()`
  Map<String, dynamic> toJson() => {
    "receiverProfileUrl": receiverProfileUrl,
    "receiverName": receiverName,
    "receiverId": receiverId,
    "isCallDialed": isCallDialed,
    "callId": callId,
    "callerProfileUrl": callerProfileUrl,
    "callerName": callerName,
    "callerId": callerId,
    "isMissed": isMissed,
    "createdAt": createdAt?.toIso8601String(),
  };

  CallModel copyWith({
    String? callId,
    String? callerId,
    String? callerName,
    String? callerProfileUrl,
    String? receiverId,
    String? receiverName,
    String? receiverProfileUrl,
    bool? isCallDialed,
    bool? isMissed,
    DateTime? createdAt,
  }) {
    return CallModel(
      callId: callId ?? this.callId,
      callerId: callerId ?? this.callerId,
      callerName: callerName ?? this.callerName,
      callerProfileUrl: callerProfileUrl ?? this.callerProfileUrl,
      receiverId: receiverId ?? this.receiverId,
      receiverName: receiverName ?? this.receiverName,
      receiverProfileUrl: receiverProfileUrl ?? this.receiverProfileUrl,
      isCallDialed: isCallDialed ?? this.isCallDialed,
      isMissed: isMissed ?? this.isMissed,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
