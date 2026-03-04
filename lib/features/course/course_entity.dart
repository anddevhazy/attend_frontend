import 'package:equatable/equatable.dart';

class CourseEntity extends Equatable {
  final String courseId;
  final String? courseCode;
  final String? courseTitle;

  const CourseEntity({
    required this.courseId,
    this.courseCode,
    this.courseTitle,
  });

  @override
  List<Object?> get props => [courseId, courseCode, courseTitle];
}
