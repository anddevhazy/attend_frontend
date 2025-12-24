import 'package:attend/features/student/mark_attendance/attendance_sim_result.dart';

class MarkAttendanceArgs {
  final String sessionCode;
  final String sessionTitle;
  final String lecturerName;
  final String venue;
  final AttendanceSimResult simResult;

  const MarkAttendanceArgs({
    required this.sessionCode,
    required this.sessionTitle,
    required this.lecturerName,
    required this.venue,
    this.simResult = AttendanceSimResult.success,
  });
}
