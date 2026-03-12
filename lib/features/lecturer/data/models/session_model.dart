import 'package:attend/features/course/course_model.dart';
import 'package:attend/features/lecturer/domain/entities/session_entity.dart';
import 'package:attend/features/location/location_model.dart';

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
      sessionId: json["id"],
      isLive: json["status"] == "live",
      sessionDate: DateTime.parse(json["createdAt"]),
      present: json["present"],
      denied: json["denied"],
      course: CourseModel.fromJson(json["course"]),
      location: LocationModel.fromJson(json["location"]),
    );
  }
}
