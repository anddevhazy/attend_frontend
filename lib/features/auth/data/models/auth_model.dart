import '../../domain/entities/auth_entity.dart';

class AuthModel {
  final String accessToken;
  final String refreshToken;
  final String userId;
  final String role;

  const AuthModel({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.role,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>;

    return AuthModel(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      userId: user['id'],
      role: user['role'],
    );
  }

  AuthEntity toEntity() {
    return AuthEntity(
      userId: userId,
      accessToken: accessToken,
      refreshToken: refreshToken,
      role: role,
    );
  }
}
