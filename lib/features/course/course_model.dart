import 'package:attend/features/course/course_entity.dart';

class CourseModel extends CourseEntity {
  const CourseModel({
    required super.courseId,
    required super.courseCode,
    required super.name,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      courseId: json['courseId'],
      courseCode: json['courseCode'],
      name: json['name'],
    );
  }
}
