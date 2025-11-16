import 'package:attend/features/app/splash_screen.dart';
import 'package:attend/features/onboarding/role_selection_screen.dart';
import 'package:attend/features/student_course_selection/presentation/pages/l;aj.dart';
import 'package:attend/features/student_dashboard/attendance_result_screen.dart';
import 'package:attend/features/student_dashboard/create_attendance_screen.dart';
import 'package:attend/features/student_dashboard/lecturer_dashboard_home_screen.dart';
import 'package:attend/features/student_dashboard/lecturer_profile_settings_screen.dart';
import 'package:attend/features/student_dashboard/live_attendance_viewer_screen.dart';
// import 'package:attend/features/student_dashboard/role_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          // home: const MyHomePage(title: 'Flutter Demo Home Page'),
          home: RoleSelectionScreen(),
        );
      },
    );
  }
}
