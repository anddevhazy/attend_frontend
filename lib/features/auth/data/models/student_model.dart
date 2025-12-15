import 'package:attend/features/auth/domain/entities/student_entity.dart';

class StudentModel extends StudentEntity {
  const StudentModel({
    required super.studentId,
    required super.email,
    required super.password,
  });

  // Convert from JSON
  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      studentId: json['studentId'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {'studentId': studentId, 'email': email, 'password': password};
  }
}
