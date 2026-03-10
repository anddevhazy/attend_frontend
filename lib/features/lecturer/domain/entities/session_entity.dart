import 'package:attend/features/course/course_entity.dart';
import 'package:attend/features/location/location_entity.dart';
import 'package:equatable/equatable.dart';

class SessionEntity extends Equatable {
  final String sessionId;
  final CourseEntity course;
  final LocationEntity location;
  final bool isLive;
  final DateTime sessionDate;
  final int? present;
  final int? denied;

  const SessionEntity({
    required this.sessionId,
    required this.course,
    required this.location,
    required this.isLive,
    required this.sessionDate,
    this.present,
    this.denied,
  });

  @override
  List<Object?> get props => [
    sessionId,
    course,
    location,
    present,
    denied,
    isLive,
    sessionDate,
  ];
}
