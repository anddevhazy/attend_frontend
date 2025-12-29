import 'package:attend/features/auth/presentation/pages/login_page.dart';
import 'package:attend/features/auth/presentation/pages/signup_page.dart';
import 'package:attend/features/lecturer/create_session/presentation/pages/create_session_page.dart';
import 'package:attend/features/lecturer/history/history_page.dart';
import 'package:attend/features/lecturer/lecturer_home/presentation/pages/lecturer_home_page.dart';
import 'package:attend/features/lecturer/review_override_request/presentation/pages/review_override_request_page.dart';
import 'package:attend/features/student/course_selection/presentation/pages/student_course_selection_page.dart';
import 'package:attend/features/student/home/presentation/pages/active_session_page.dart';
import 'package:attend/features/student/home/presentation/pages/student_home_page.dart';
import 'package:attend/features/student/mark_attendance/presentation/pages/mark_attendance_screen.dart';
import 'package:attend/features/student/mark_attendance/presentation/pages/request_manual_override_page.dart';
import 'package:attend/global/enums/role.dart';
import 'package:attend/global/pages/onboarding_screen.dart';
import 'package:attend/global/pages/role_selection/presentation/pages/role_selection_page.dart';
import 'package:attend/global/pages/splash_screen.dart';
import 'package:attend/features/student/mark_attendance/mark_attendance_args.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Routes {
  static const String splashPath = '/splash';
  static const String splashName = 'splash';

  static const String onboardingPath = '/onboarding';
  static const String onboardingName = 'onboarding';

  static const String roleSelectionPath = '/roleSelection';
  static const String roleSelectionName = 'roleSelection';

  static const String signUpPath = '/signUp';
  static const String signUpName = 'signUp';

  static const String studentCourseSelectionPath = '/studentCourseSelection';
  static const String studentCourseSelectionName = 'studentCourseSelection';

  static const String loginPath = '/login';
  static const String loginName = 'login';

  static const String studentHomePath = '/studentHome';
  static const String studentHomeName = 'studentHome';

  static const String activeSessionPath = '/activeSession';
  static const String activeSessionName = 'activeSession';

  static const String markAttendancePath = '/markAttendance';
  static const String markAttendanceName = 'markAttendance';

  static const String requestManualOverridePath = '/requestManualOverride';
  static const String requestManualOverrideName = 'requestManualOverride';

  static const String lecturerHomePath = '/lecturerHome';
  static const String lecturerHomeName = 'lecturerHome';

  static const String createSessionPath = '/createSession';
  static const String createSessionName = 'createSession';

  static const String reviewOverrideRequestPath = '/reviewOverrideRequest';
  static const String reviewOverrideRequestName = 'reviewOverrideRequest';

  static const String lecturerHistoryPath = '/lecturerHistory';
  static const String lecturerHistoryName = 'lecturerHistory';

  // static const String credentialUploadPath = '/credentialUpload';
  // static const String credentialUploadName = 'credentialUpload';

  //   static const String attendanceResultPath = '/attendanceResult';
  // static const String attendanceResultName = 'attendanceResult';

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> shellNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,

    initialLocation: splashPath,

    routes: [
      GoRoute(
        path: splashPath,
        name: splashName,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: lecturerHistoryPath,
        name: lecturerHistoryName,
        builder: (context, state) => const LecturerHistoryGradingPage(),
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
        path: signUpPath,
        name: signUpName,
        builder: (context, state) {
          final role = state.extra as Role;
          return SignupPage(role: role);
        },
      ),
      GoRoute(
        path: studentCourseSelectionPath,
        name: studentCourseSelectionName,
        builder: (context, state) => const StudentCourseSelectionPage(),
      ),
      GoRoute(
        path: loginPath,
        name: loginName,
        builder: (context, state) {
          final role = state.extra as Role;
          return LoginPage(role: role);
        },
      ),
      GoRoute(
        path: Routes.studentHomePath,
        name: Routes.studentHomeName,
        builder: (context, state) {
          final status = state.uri.queryParameters['status'];
          return StudentHomePage(initialStatus: status);
        },
      ),
      GoRoute(
        path: activeSessionPath,
        name: activeSessionName,
        builder: (context, state) => const ActiveSessionPage(),
      ),

      GoRoute(
        path: markAttendancePath,
        name: markAttendanceName,
        builder: (context, state) {
          final args = state.extra as MarkAttendanceArgs;

          return MarkAttendanceScreen(
            sessionCode: args.sessionCode,
            sessionTitle: args.sessionTitle,
            lecturerName: args.lecturerName,
            venue: args.venue,
            simResult: args.simResult,
          );
        },
      ),

      GoRoute(
        path: requestManualOverridePath,
        name: requestManualOverrideName,
        builder: (context, state) => const RequestManualOverridePage(),
      ),
      // In your router file
      GoRoute(
        path: Routes.lecturerHomePath,
        name: Routes.lecturerHomeName,
        builder: (context, state) {
          final status = state.uri.queryParameters['status'];
          return LecturerHomePage(initialStatus: status);
        },
      ),
      GoRoute(
        path: createSessionPath,
        name: createSessionName,
        builder: (context, state) => const CreateSessionPage(),
      ),
      GoRoute(
        path: reviewOverrideRequestPath,
        name: reviewOverrideRequestName,
        builder: (context, state) => const ReviewOverrideRequestPage(),
      ),
      // GoRoute(
      //   path: credentialUploadPath,
      //   name: credentialUploadName,
      //   builder: (context, state) => const CredentialUploadPage(),
      // ),
      // GoRoute(
      //   path: attendanceResultPath,
      //   name: attendanceResultName,
      //   builder: (context, state) => const AttendanceResultPage(),
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
