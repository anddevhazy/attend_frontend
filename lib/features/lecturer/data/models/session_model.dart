import 'package:attend/features/course/course_entity.dart';
import 'package:attend/features/lecturer/domain/entities/session_entity.dart';
import 'package:attend/features/location/location_entity.dart';

class SessionModel extends SessionEntity {
  const SessionModel({
    required super.sessionId,
    required super.course,
    required super.location,
    required super.isLive,
    required super.sessionDate,
    super.present,
    super.denied,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      sessionId: json['id'],
      course: CourseEntity(
        courseId: json['courseId'],
        courseCode: '',
        name: '',
      ),
      location: LocationEntity(locationId: json['locationId']),
      isLive: json['status'] == 'live',
      sessionDate: DateTime.parse(json['createdAt']),
      present: json['present'],
      denied: json['denied'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'courseId': course.courseId, 'locationId': location.locationId};
  }
}
