import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user_entity.freezed.dart';

@freezed
class AuthUserEntity with _$AuthUserEntity {
  const factory AuthUserEntity({
    required String uid,
    required String email,
    required String name,
    required String phoneNumber,
    String? photoUrl,
    required bool isOnline,
    DateTime? lastSeen,
  }) = _AuthUserEntity;
}
