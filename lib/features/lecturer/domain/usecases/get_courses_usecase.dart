import 'package:attend/features/course/course_entity.dart';
import 'package:attend/features/lecturer/data/data_sources/local/course_local_data_souce.dart';

class GetCoursesUsecase {
  final CourseLocalDataSource local;

  GetCoursesUsecase({required this.local});

  Future<List<CourseEntity>> call() async {
    return await local.getCourses();
  }
}
