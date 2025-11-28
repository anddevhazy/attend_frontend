import 'package:equatable/equatable.dart';

class LecturerEntity extends Equatable {
  final String lecturerId;
  final String email;
  final String password;

  const LecturerEntity({
    required this.lecturerId,
    required this.email,
    required this.password,
  });

  // Implement the copyWith method
  LecturerEntity copyWith({
    String? lecturerId,
    String? email,
    String? password,
  }) {
    return LecturerEntity(
      lecturerId: lecturerId ?? this.lecturerId,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  List<Object?> get props => [lecturerId, email, password];
}
