import '../../domain/entities/auth_entity.dart';

class AuthModel extends AuthEntity {
  const AuthModel({
    required super.accessToken,
    required super.refreshToken,
    required super.userId,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>;

    return AuthModel(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      userId: user['id'],
    );
  }

  // AuthEntity toEntity() {
  //   return AuthEntity(
  //     userId: userId,
  //     accessToken: accessToken,
  //     refreshToken: refreshToken,
  //   );
  // }
}
