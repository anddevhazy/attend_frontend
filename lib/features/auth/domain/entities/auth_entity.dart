import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String userId;
  final String accessToken;
  final String refreshToken;
  final String role;

  const AuthEntity({
    required this.userId,
    required this.accessToken,
    required this.refreshToken,
    required this.role,
  });

  @override
  List<Object?> get props => [userId, accessToken, refreshToken, role];
}
