import 'package:attend/features/student/auth/presentation/pages/student_login_page.dart';
import 'package:attend/features/student/auth/presentation/pages/student_signup_page.dart';
import 'package:attend/features/student/course_selection/presentation/pages/student_course_selection_page.dart';
import 'package:attend/features/student/dashboard/presentation/pages/student_dashboard_page.dart';
import 'package:attend/global/pages/onboarding_screen.dart';
import 'package:attend/global/pages/role_selection_page.dart';
import 'package:attend/global/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Routes {
  static const String splashPath = '/splash';
  static const String splashName = 'splash';

  static const String onboardingPath = '/onboarding';
  static const String onboardingName = 'onboarding';

  static const String roleSelectionPath = '/roleSelection';
  static const String roleSelectionName = 'roleSelection';

  static const String studentSignUpPath = '/studentSignUp';
  static const String studentSignUpName = 'studentSignUp';

  static const String studentCourseSelectionPath = '/studentCourseSelection';
  static const String studentCourseSelectionName = 'studentCourseSelection';

  static const String lecturerSignUpPath = '/lecturerSignUp';
  static const String lecturerSignUpName = 'lecturerSignUp';

  static const String studentLoginPath = '/studentLogin';
  static const String studentLoginName = 'studentLogin';

  static const String studentDashboardPath = '/studentDashboard';
  static const String studentDashboardName = 'studentDashboard';

  static const String credentialUploadPath = '/credentialUpload';
  static const String credentialUploadName = 'credentialUpload';

  static const String markAttendancePath = '/markAttendance';
  static const String markAttendanceName = 'markAttendance';

  static const String attendanceResultPath = '/attendanceResult';
  static const String attendanceResultName = 'attendanceResult';

  static const String overrideRequestPath = '/overrideRequest';
  static const String overrideRequestName = 'overrideRequest';

  static const String lecturerHomePath = '/lecturerHome';
  static const String lecturerHomeName = 'lecturerHome';

  static const String createSessionPath = '/createSession';
  static const String createSessionName = 'createSession';

  static const String reviewOverrideRequestPath = '/reviewOverrideRequest';
  static const String reviewOverrideRequestName = 'reviewOverrideRequest';

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> shellNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,

    // initialLocation: splashPath,
    initialLocation: studentDashboardPath,

    routes: [
      GoRoute(
        path: splashPath,
        name: splashName,
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        path: onboardingPath,
        name: onboardingName,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const OnboardingScreen(),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              final curved = CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              );

              return FadeTransition(opacity: curved, child: child);
            },
          );
        },
      ),

      GoRoute(
        path: roleSelectionPath,
        name: roleSelectionName,
        builder: (context, state) => const RoleSelectionPage(),
      ),
      GoRoute(
        path: studentSignUpPath,
        name: studentSignUpName,
        builder: (context, state) => const StudentSignUpPage(),
      ),
      GoRoute(
        path: studentCourseSelectionPath,
        name: studentCourseSelectionName,
        builder: (context, state) => const StudentCourseSelectionPage(),
      ),
      // GoRoute(
      //   path: lecturerSignUpPath,
      //   name: lecturerSignUpName,
      //   builder: (context, state) => const LecturerSignUpPage(),
      // ),
      GoRoute(
        path: studentLoginPath,
        name: studentLoginName,
        builder: (context, state) => const StudentLoginPage(),
      ),
      GoRoute(
        path: studentDashboardPath,
        name: studentDashboardName,
        builder: (context, state) => const StudentDashboardPage(),
      ),
      // GoRoute(
      //   path: credentialUploadPath,
      //   name: credentialUploadName,
      //   builder: (context, state) => const CredentialUploadPage(),
      // ),
      // GoRoute(
      //   path: markAttendancePath,
      //   name: markAttendanceName,
      //   builder: (context, state) => const MarkAttendancePage(),
      // ),
      // GoRoute(
      //   path: attendanceResultPath,
      //   name: attendanceResultName,
      //   builder: (context, state) => const AttendanceResultPage(),
      // ),
      // GoRoute(
      //   path: overrideRequestPath,
      //   name: overrideRequestName,
      //   builder: (context, state) => const OverrideRequestPage(),
      // ),
      // GoRoute(
      //   path: lecturerHomePath,
      //   name: lecturerHomeName,
      //   builder: (context, state) => const LecturerHomePage(),
      // ),
      // GoRoute(
      //   path: createSessionPath,
      //   name: createSessionName,
      //   builder: (context, state) => const CreateSessionPage(),
      // ),

      // GoRoute(
      //   path: reviewOverrideRequestPath,
      //   name: reviewOverrideRequestName,
      //   builder: (context, state) => const ReviewOverrideRequestPage(),
      // ),

      // ShellRoute(
      //   navigatorKey: shellNavigatorKey,
      //   builder:
      //       (context, state, child) =>
      //           MainScreen(routeState: state, child: child),
      //   routes: [
      //     GoRoute(
      //       path: studentHomePath,
      //       name: studentHomeName,
      //       builder: (context, state) => const StudentHomePage(),
      //     ),
      //     GoRoute(
      //       path: lecturerHomePath,
      //       name: lecturerHomeName,
      //       builder: (context, state) => const LecturerHomePage(),
      //     ),
      //     GoRoute(
      //       path: settingsPath,
      //       name: settingsName,
      //       builder: (context, state) => const SettingsPage(),
      //     ),
      //   ],
      // ),
    ],
    errorBuilder:
        (context, state) =>
            Scaffold(body: Center(child: Text(state.error.toString()))),
  );
}
