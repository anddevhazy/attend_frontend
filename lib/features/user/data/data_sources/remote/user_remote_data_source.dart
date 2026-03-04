// import 'package:dio/dio.dart';
// import 'package:retrofit/retrofit.dart';
// import 'package:whatsapp_clone/features/user/data/models/user_model.dart';
// import 'package:whatsapp_clone/features/user/data/models/user_presence_model.dart';

// part 'user_remote_data_source.g.dart';

// @RestApi()
// abstract class UserRemoteDataSource {
//   factory UserRemoteDataSource(Dio dio, {String baseUrl}) =
//       _UserRemoteDataSource;

//   @GET('/users')
//   Future<List<UserModel>> getAllUsers();

//   @GET('/users/me')
//   Future<UserModel> getCurrentUser();

//   @GET('/users/{uid}')
//   Future<UserModel> getUserById(@Path('uid') String uid);

//   @GET('/users/search')
//   Future<List<UserModel>> searchUsers(@Query('q') String query);

//   @PATCH('/users/me')
//   Future<UserModel> updateUser(@Body() Map<String, dynamic> updates);

//   @PATCH('/users/me/presence')
//   Future<void> updatePresence(@Body() UserPresenceModel presence);
// }
