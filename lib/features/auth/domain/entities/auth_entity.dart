import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String userId;
  final String token;
  final String role;

  const AuthEntity({
    required this.userId,
    required this.token,
    required this.role,
  });

  @override
  List<Object?> get props => [userId, token, role];
}
