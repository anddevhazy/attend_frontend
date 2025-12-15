import 'package:attend/features/auth/data/models/student_model.dart';

class AuthResponseModel {
  final String accessToken;
  final String refreshToken;
  final StudentModel student;

  const AuthResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.student,
  });

  // From JSON
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      student: StudentModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}
