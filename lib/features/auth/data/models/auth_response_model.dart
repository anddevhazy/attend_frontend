// lib/features/auth/data/models/auth_response_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_response_model.freezed.dart';
part 'auth_response_model.g.dart';

@freezed
class AuthResponseModel with _$AuthResponseModel {
  const factory AuthResponseModel({
    /// The authenticated user data
    required UserModel user,

    /// Access token (JWT) - used for authenticated requests
    required String accessToken,

    /// Refresh token - used to get new access token when expired
    required String refreshToken,

    /// When the access token expires (in seconds or ISO string)
    @JsonKey(name: 'expires_in') required int expiresIn,

    /// Optional: token type, usually "Bearer"
    @Default('Bearer') String tokenType,
  }) = _AuthResponseModel;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);
}

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String uid,
    required String email,
    String? name,
    String? phoneNumber,
    String? photoUrl,
    String? status,
    @Default(false) bool isOnline,

    /// Timestamp when user was created (ISO or milliseconds)
    @JsonKey(name: 'created_at') String? createdAt,

    /// Last seen timestamp
    @JsonKey(name: 'last_seen') String? lastSeen,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
