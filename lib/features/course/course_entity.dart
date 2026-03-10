import 'package:equatable/equatable.dart';

class CourseEntity extends Equatable {
  final String courseId;
  final String courseCode;
  final String name;

  const CourseEntity({
    required this.courseId,
    required this.courseCode,
    required this.name,
  });

  @override
  List<Object?> get props => [courseId, courseCode, name];
}
