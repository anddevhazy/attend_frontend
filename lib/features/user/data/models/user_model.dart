import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:whatsapp_clone/features/user/domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String uid,
    required String name,
    required String phoneNumber,
    required String email,
    String? photoUrl,
    String? status,
    @Default(false) bool isOnline,
    DateTime? lastSeen,
    DateTime? createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

extension UserModelX on UserModel {
  UserEntity toEntity() => UserEntity(
    uid: uid,
    name: name,
    phoneNumber: phoneNumber,
    email: email,
    photoUrl: photoUrl,
    status: status,
    isOnline: isOnline,
    lastSeen: lastSeen,
    createdAt: createdAt,
  );
}
