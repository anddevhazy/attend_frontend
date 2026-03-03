import 'package:attend/core/network/api_client.dart';
import 'package:attend/core/network/api_endpoints.dart';
import 'package:attend/features/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:attend/features/auth/domain/entities/auth_entity.dart';
import 'package:attend/features/lecturer/lecturer_entity.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient client;
  final GoogleSignIn googleSignIn;

  AuthRemoteDataSourceImpl({required this.client, required this.googleSignIn});

  @override
  Future<(AuthEntity, LecturerEntity)> continueWithGoogle() async {
    // 1️⃣ Authenticate with Google
    final googleUser = await googleSignIn.authenticate();

    // 2️⃣ Retrieve authentication tokens
    final googleAuth = googleUser.authentication;

    final idToken = googleAuth.idToken;

    if (idToken == null) {
      throw Exception('Failed to retrieve Google idToken');
    }

    // 3️⃣ Send idToken to backend
    final response = await client.postRequest(
      ApiEndpoints.continuewithGoogle,
      data: {"idToken": idToken},
    );

    final data = response.data as Map<String, dynamic>;

    final token = data['token'] as String;
    final userMap = data['user'] as Map<String, dynamic>;

    final authEntity = AuthEntity(
      userId: userMap['id'],
      token: token,
      role: userMap['role'],
    );

    final userEntity = LecturerEntity(
      id: userMap['id'],
      name: userMap['name'],
      email: userMap['email'],
      role: userMap['role'],
    );

    return (authEntity, userEntity);
  }
}
