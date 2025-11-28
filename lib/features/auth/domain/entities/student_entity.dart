import 'package:equatable/equatable.dart';

class StudentEntity extends Equatable {
  final String studentId;
  final String email;
  final String password;

  const StudentEntity({
    required this.studentId,
    required this.email,
    required this.password,
  });

  // Implement the copyWith method
  StudentEntity copyWith({String? studentId, String? email, String? password}) {
    return StudentEntity(
      studentId: studentId ?? this.studentId,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  List<Object?> get props => [studentId, email, password];
}
