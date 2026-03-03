import '../../domain/entities/auth_entity.dart';

class AuthModel {
  final String token;
  final String userId;
  final String role;

  const AuthModel({
    required this.token,
    required this.userId,
    required this.role,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      token: json['token'],
      userId: json['user']['id'],
      role: json['user']['role'],
    );
  }

  AuthEntity toEntity() {
    return AuthEntity(userId: userId, token: token, role: role);
  }
}
