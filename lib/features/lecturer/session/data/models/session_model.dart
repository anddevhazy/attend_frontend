import 'package:attend/features/course/course_entity.dart';
import 'package:attend/features/lecturer/session/domain/entities/session_entity.dart';
import 'package:attend/features/location/location_entity.dart';

class SessionModel extends SessionEntity {
  const SessionModel({
    required super.sessionId,
    required super.courseId,
    required super.locationId,
    required super.isLive,
    required super.sessionDate,
    super.present,
    super.denied,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      sessionId: json['id'],
      courseId: CourseEntity(courseId: json['courseId']),
      locationId: LocationEntity(locationId: json['locationId']),
      isLive: json['status'] == 'live',
      sessionDate: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'courseId': courseId.courseId, 'locationId': locationId.locationId};
  }
}
