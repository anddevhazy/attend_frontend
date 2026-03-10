import 'package:attend/features/course/course_entity.dart';

class Courses {
  static const List<CourseEntity> courses = [
    CourseEntity(
      courseId: "69afbfccd957effbf4125c0f",
      name: "Control Engineering",
      courseCode: "EEE405",
    ),
    CourseEntity(
      courseId: "69afbfdad957effbf4125c11",
      name: "Power Systems",
      courseCode: "EEE401",
    ),
  ];
}

class CourseLocalDataSource {
  Future<List<CourseEntity>> getCourses() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Courses.courses;
  }
}
