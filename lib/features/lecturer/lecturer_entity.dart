import 'package:equatable/equatable.dart';

class LecturerEntity extends Equatable {
  final String lecturerId;
  final String name;
  final String email;
  final String role;

  const LecturerEntity({
    required this.lecturerId,
    required this.name,
    required this.email,
    required this.role,
  });

  @override
  List<Object?> get props => [lecturerId, name, email, role];
}
