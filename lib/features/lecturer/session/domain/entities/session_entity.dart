import 'package:attend/features/course/course_entity.dart';
import 'package:attend/features/location/location_entity.dart';
import 'package:equatable/equatable.dart';

class SessionEntity extends Equatable {
  final String sessionId;
  final CourseEntity courseId;
  final LocationEntity locationId;
  final bool isLive;
  final DateTime sessionDate;
  final int? present;
  final int? denied;

  const SessionEntity({
    required this.sessionId,
    required this.courseId,
    required this.locationId,
    required this.isLive,
    required this.sessionDate,
    this.present,
    this.denied,
  });

  @override
  List<Object?> get props => [
    sessionId,
    courseId,
    locationId,
    present,
    denied,
    isLive,
    sessionDate,
  ];
}
