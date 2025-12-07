/// Paths only; base URL comes from FlavorConfig.
library;

class ApiEndpoints {
  static const String base = '/api/v1';

  // ---------------- AUTH ----------------
  static const String lecturerSignup = '$base/auth/lecturer-signup';
  static const String studentSignup = '$base/auth/student-signup';

  static const String verifyLecturerEmail = '$base/auth/verify-lecturer-email';
  static const String verifyStudentEmail = '$base/auth/verify-student-email';

  static const String lecturerLogin = '$base/auth/lecturer-login';
  static const String studentLogin = '$base/auth/student-login';

  // ---------------- LECTURER ----------------
  static const String createSession = '$base/lecturer/create-session';
  static String getOverrideRequests(String sessionId) =>
      '$base/lecturer/get-override-requests/$sessionId';

  static const String approveOverride = '$base/lecturer/approve-override';
  static const String denyOverride = '$base/lecturer/deny-override';

  // ---------------- STUDENT ----------------
  static const String fetchCourses = '$base/student/fetch-courses';
  static const String selectCourses = '$base/student/select-courses';

  static const String uploadCourseFormAndExtract =
      '$base/student/course-form-upload-and-extract';
  static const String uploadResultAndExtract =
      '$base/student/result-upload-and-extract';

  static const String confirmActivation = '$base/student/confirm-activation';

  static const String getLiveClasses = '$base/student/get-live-classes';

  static const String markAttendance = '$base/student/mark-attendance';

  static const String uploadSelfieAndRegisterDevice =
      '$base/student/upload-selfie-and-register-device';

  static const String requestOverride = '$base/student/request-override';
}
