// import 'package:retrofit/retrofit.dart';
// import 'package:dio/dio.dart';
// import 'package:whatsapp_clone/features/auth/data/models/auth_response_model.dart';

// part 'auth_remote_data_source.g.dart';

// @RestApi()
// abstract class AuthRemoteDataSource {
//   factory AuthRemoteDataSource(Dio dio, {String baseUrl}) =
//       _AuthRemoteDataSource;

//   @POST('/auth/login')
//   Future<AuthResponseModel> login({@Body() required Map<String, dynamic> body});

//   @POST('/auth/register')
//   Future<AuthResponseModel> register({
//     @Body() required Map<String, dynamic> body,
//   });

//   @POST('/auth/auth/refresh-token')
//   Future<AuthResponseModel> refreshToken({
//     @Field('refreshToken') required String refreshToken,
//   });

//   @POST('/auth/logout')
//   Future<void> logout();
// }


// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'auth_remote_data_source.dart';

// // **************************************************************************
// // RetrofitGenerator
// // **************************************************************************

// class _AuthRemoteDataSource implements AuthRemoteDataSource {
//   _AuthRemoteDataSource(this._dio, {this.baseUrl}) {
//     baseUrl ??= 'https://api.example.com'; // default base URL if not provided
//   }

//   final Dio _dio;
//   String? baseUrl;

//   @override
//   Future<AuthResponseModel> login({required Map<String, dynamic> body}) async {
//     final response = await _dio.post(
//       '/auth/login',
//       data: body,
//     );
//     return AuthResponseModel.fromJson(response.data);
//   }

//   @override
//   Future<AuthResponseModel> register({required Map<String, dynamic> body}) async {
//     final response = await _dio.post(
//       '/auth/register',
//       data: body,
//     );
//     return AuthResponseModel.fromJson(response.data);
//   }

//   @override
//   Future<AuthResponseModel> refreshToken({required String refreshToken}) async {
//     final response = await _dio.post(
//       '/auth/auth/refresh-token',
//       data: {'refreshToken': refreshToken},
//     );
//     return AuthResponseModel.fromJson(response.data);
//   }

//   @override
//   Future<void> logout() async {
//     await _dio.post('/auth/logout');
//   }
// }




// ///GROK+

// import 'package:attend/core/error/failures.dart';
// import 'package:attend/core/network/network_info.dart';
// import 'package:attend/features/auth/data/data_sources/remote/auth_remote_data_source.dart';
// import 'package:attend/features/auth/domain/repositories/auth_repository.dart';
// import 'package:dartz/dartz.dart';

// class AuthRepositoryImpl implements AuthRepository {
//   final AuthRemoteDataSource remoteDataSource;
//   final NetworkInfo networkInfo;

//   AuthRepositoryImpl({
//     required this.remoteDataSource,
//     required this.networkInfo,
//   });

//   // @override
//   // Future<Either<Failure, AuthUserEntity>> login({
//   //   required String phoneOrEmail,
//   //   required String password,
//   // }) async {
//   //   if (!await networkInfo.isConnected) {
//   //     return Left(NetworkFailure());
//   //   }

//   //   try {
//   //     final response = await remoteDataSource.login(
//   //       body: {'identifier': phoneOrEmail, 'password': password},
//   //     );
//   //     // Save tokens securely (e.g., flutter_secure_storage)
//   //     await _saveTokens(response.accessToken, response.refreshToken);
//   //     return Right(response.user.toEntity());
//   //   } on ServerException catch (e) {
//   //     return Left(ServerFailure(e.message));
//   //   } on UnauthorizedException {
//   //     return Left(UnauthorizedFailure());
//   //   } catch (_) {
//   //     return Left(ServerFailure('Login failed'));
//   //   }
//   // }

//   @override
//   Future<Either<Failure, AuthUserEntity>> register({
//     required String name,
//     required String phoneNumber,
//     required String password,
//   }) async {
//     if (!await networkInfo.isConnected) return Left(NetworkFailure());

//     try {
//       final response = await remoteDataSource.register(
//         body: {'name': name, 'phoneNumber': phoneNumber, 'password': password},
//       );
//       await _saveTokens(response.accessToken, response.refreshToken);
//       return Right(response.user.toEntity());
//     } on ServerException catch (e) {
//       return Left(ServerFailure(e.message));
//     } catch (_) {
//       return Left(ServerFailure('Registration failed'));
//     }
//   }

//   // @override
//   // Future<Either<Failure, Unit>> logout() async {
//   //   try {
//   //     await remoteDataSource.logout();
//   //     await _clearTokens();
//   //     return const Right(unit);
//   //   } catch (_) {
//   //     return const Right(unit); // Logout locally even if server fails
//   //   }
//   // }

//   // @override
//   // Future<Either<Failure, AuthUserEntity>> refreshToken(
//   //   String refreshToken,
//   // ) async {
//   //   try {
//   //     final response = await remoteDataSource.refreshToken(
//   //       refreshToken: refreshToken,
//   //     );
//   //     await _saveTokens(response.accessToken, response.refreshToken);
//   //     return Right(response.user.toEntity());
//   //   } on UnauthorizedException {
//   //     await _clearTokens();
//   //     return Left(UnauthorizedFailure());
//   //   } catch (_) {
//   //     return Left(ServerFailure('Token refresh failed'));
//   //   }
//   // }

//   // Helper methods (use flutter_secure_storage in real app)
//   Future<void> _saveTokens(String access, String refresh) async {
//     // TODO: Save using flutter_secure_storage
//   }

//   Future<void> _clearTokens() async {
//     // TODO: Clear tokens
//   }
// }
