import 'package:attend/features/lecturer/domain/entities/lecturer_entity.dart';

class LecturerModel extends LecturerEntity {
  const LecturerModel({
    required super.lecturerId,
    required super.name,
    required super.email,
    required super.role,
  });

  factory LecturerModel.fromJson(Map<String, dynamic> json) {
    return LecturerModel(
      lecturerId: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': lecturerId, 'name': name, 'email': email, 'role': role};
  }
}
