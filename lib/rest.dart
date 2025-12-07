



// Feature: Call
// lib/features/call/data/models/call_model.dart
// // lib/features/call/data/models/call_model.dart

// import '../../domain/entities/call_entity.dart';

// class CallModel extends CallEntity {
//   const CallModel({
//     required super.id,
//     required super.callerId,
//     required super.receiverId,
//     required super.channelId,
//     required super.isVideoCall,
//     required super.createdAt,
//     super.endedAt,
//     super.status,
//   });

//   factory CallModel.fromJson(Map<String, dynamic> json) {
//     return CallModel(
//       id: json['id'] as String,
//       callerId: json['callerId'] as String,
//       receiverId: json['receiverId'] as String,
//       channelId: json['channelId'] as String,
//       isVideoCall: json['isVideoCall'] as bool? ?? false,
//       createdAt: DateTime.parse(json['createdAt'] as String),
//       endedAt: json['endedAt'] != null
//           ? DateTime.parse(json['endedAt'] as String)
//           : null,
//       status: json['status'] as String?,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'callerId': callerId,
//       'receiverId': receiverId,
//       'channelId': channelId,
//       'isVideoCall': isVideoCall,
//       'createdAt': createdAt.toIso8601String(),
//       'endedAt': endedAt?.toIso8601String(),
//       'status': status,
//     };
//   }

//   CallModel copyWith({
//     String? id,
//     String? callerId,
//     String? receiverId,
//     String? channelId,
//     bool? isVideoCall,
//     DateTime? createdAt,
//     DateTime? endedAt,
//     String? status,
//   }) {
//     return CallModel(
//       id: id ?? this.id,
//       callerId: callerId ?? this.callerId,
//       receiverId: receiverId ?? this.receiverId,
//       channelId: channelId ?? this.channelId,
//       isVideoCall: isVideoCall ?? this.isVideoCall,
//       createdAt: createdAt ?? this.createdAt,
//       endedAt: endedAt ?? this.endedAt,
//       status: status ?? this.status,
//     );
//   }
// }


// lib/features/call/data/remote/call_remote_data_source_impl.dart
// // lib/features/call/data/remote/call_remote_data_source_impl.dart

// import 'package:dio/dio.dart';
// import '../../../../core/network/api_client.dart';
// import '../../../../core/network/api_endpoints.dart';
// import '../models/call_model.dart';
// import 'call_remote_data_source.dart';

// class CallRemoteDataSourceImpl implements CallRemoteDataSource {
//   final ApiClient _client;

//   CallRemoteDataSourceImpl(this._client);

//   @override
//   Future<CallModel> makeCall({
//     required String callerId,
//     required String receiverId,
//     required bool isVideoCall,
//   }) async {
//     final response = await _client.postRequest<Map<String, dynamic>>(
//       ApiEndpoints.calls,
//       data: {
//         'callerId': callerId,
//         'receiverId': receiverId,
//         'isVideoCall': isVideoCall,
//       },
//     );
//     return CallModel.fromJson(response.data!);
//   }

//   @override
//   Future<void> endCall(String callId) async {
//     await _client.postRequest<void>(
//       '${ApiEndpoints.callById(callId)}/end',
//     );
//   }

//   @override
//   Future<List<CallModel>> getMyCallHistory() async {
//     final response = await _client.getRequest<List<dynamic>>(
//       ApiEndpoints.myCallHistory,
//     );
//     final list = response.data ?? [];
//     return list
//         .map((e) => CallModel.fromJson(e as Map<String, dynamic>))
//         .toList();
//   }

//   @override
//   Future<CallModel?> getUserCalling(String userId) async {
//     final response = await _client.getRequest<Map<String, dynamic>>(
//       '${ApiEndpoints.calls}?userId=$userId&status=ongoing',
//     );
//     if (response.data == null || response.data!.isEmpty) return null;
//     return CallModel.fromJson(response.data!);
//   }

//   @override
//   Future<String> getCallChannelId({
//     required String callerId,
//     required String receiverId,
//   }) async {
//     final response = await _client.postRequest<Map<String, dynamic>>(
//       ApiEndpoints.callChannel,
//       data: {
//         'callerId': callerId,
//         'receiverId': receiverId,
//       },
//     );
//     return response.data?['channelId'] as String;
//   }

//   @override
//   Future<void> saveCallHistory(CallModel call) async {
//     await _client.postRequest<void>(
//       '${ApiEndpoints.calls}/${call.id}/history',
//       data: call.toJson(),
//     );
//   }

//   @override
//   Future<void> updateCallHistoryStatus({
//     required String callId,
//     required String status,
//   }) async {
//     await _client.putRequest<void>(
//       ApiEndpoints.callById(callId),
//       data: {
//         'status': status,
//       },
//     );
//   }
// }

// This assumes you have an abstract CallRemoteDataSource declared in call_remote_data_source.dart with the methods used here.

// lib/features/call/call_injection_container.dart
// // lib/features/call/call_injection_container.dart

// import 'package:get_it/get_it.dart';

// import '../../core/network/api_client.dart';
// import 'data/remote/call_remote_data_source.dart';
// import 'data/remote/call_remote_data_source_impl.dart';
// import 'data/repository/call_repository_impl.dart';
// import 'domain/repository/call_repository.dart';
// import 'domain/usecases/end_call_usecase.dart';
// import 'domain/usecases/get_call_channel_id_usecase.dart';
// import 'domain/usecases/get_my_call_history_usecase.dart';
// import 'domain/usecases/get_user_calling_usecase.dart';
// import 'domain/usecases/make_call_usecase.dart';
// import 'domain/usecases/save_call_history_usecase.dart';
// import 'domain/usecases/update_call_history_status_usecase.dart';
// import 'presentation/cubits/call/call_cubit.dart';
// import 'presentation/cubits/my_call_history/my_call_history_cubit.dart';
// import 'presentation/cubits/agora/agora_cubit.dart';

// final sl = GetIt.instance;

// void initCallFeature() {
//   // Data sources
//   sl.registerLazySingleton<CallRemoteDataSource>(
//     () => CallRemoteDataSourceImpl(sl<ApiClient>()),
//   );

//   // Repository
//   sl.registerLazySingleton<CallRepository>(
//     () => CallRepositoryImpl(sl<CallRemoteDataSource>()),
//   );

//   // Use cases
//   sl.registerLazySingleton(() => MakeCallUseCase(sl<CallRepository>()));
//   sl.registerLazySingleton(() => EndCallUseCase(sl<CallRepository>()));
//   sl.registerLazySingleton(() => GetMyCallHistoryUseCase(sl<CallRepository>()));
//   sl.registerLazySingleton(() => GetUserCallingUseCase(sl<CallRepository>()));
//   sl.registerLazySingleton(() => SaveCallHistoryUseCase(sl<CallRepository>()));
//   sl.registerLazySingleton(
//       () => UpdateCallHistoryStatusUseCase(sl<CallRepository>()));
//   sl.registerLazySingleton(
//       () => GetCallChannelIdUseCase(sl<CallRepository>()));

//   // Cubits
//   sl.registerFactory(
//     () => CallCubit(
//       makeCallUseCase: sl(),
//       endCallUseCase: sl(),
//       getUserCallingUseCase: sl(),
//       saveCallHistoryUseCase: sl(),
//       updateCallHistoryStatusUseCase: sl(),
//       getCallChannelIdUseCase: sl(),
//     ),
//   );

//   sl.registerFactory(
//     () => MyCallHistoryCubit(
//       getMyCallHistoryUseCase: sl(),
//     ),
//   );

//   sl.registerFactory(
//     () => AgoraCubit(),
//   );
// }


// Feature: Chat
// lib/features/chat/data/models/chat_model.dart
// // lib/features/chat/data/models/chat_model.dart

// import '../../domain/entities/chat_entity.dart';
// import 'message_model.dart';

// class ChatModel extends ChatEntity {
//   const ChatModel({
//     required super.id,
//     required super.participantIds,
//     required super.lastMessage,
//     required super.updatedAt,
//     super.unreadCount,
//   });

//   factory ChatModel.fromJson(Map<String, dynamic> json) {
//     return ChatModel(
//       id: json['id'] as String,
//       participantIds: List<String>.from(json['participantIds'] as List),
//       lastMessage: json['lastMessage'] != null
//           ? MessageModel.fromJson(json['lastMessage'] as Map<String, dynamic>)
//           : null,
//       updatedAt: DateTime.parse(json['updatedAt'] as String),
//       unreadCount: json['unreadCount'] as int? ?? 0,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'participantIds': participantIds,
//       'lastMessage': lastMessage is MessageModel
//           ? (lastMessage as MessageModel).toJson()
//           : null,
//       'updatedAt': updatedAt.toIso8601String(),
//       'unreadCount': unreadCount,
//     };
//   }
// }


// lib/features/chat/data/models/message_model.dart
// // lib/features/chat/data/models/message_model.dart

// import '../../domain/entities/message_entity.dart';
// import '../../domain/entities/message_reply_entity.dart';

// class MessageModel extends MessageEntity {
//   const MessageModel({
//     required super.id,
//     required super.chatId,
//     required super.senderId,
//     required super.text,
//     required super.type,
//     required super.createdAt,
//     required super.isSeen,
//     super.reply,
//     super.mediaUrl,
//     super.durationInSeconds,
//   });

//   factory MessageModel.fromJson(Map<String, dynamic> json) {
//     return MessageModel(
//       id: json['id'] as String,
//       chatId: json['chatId'] as String,
//       senderId: json['senderId'] as String,
//       text: json['text'] as String? ?? '',
//       type: json['type'] as String,
//       createdAt: DateTime.parse(json['createdAt'] as String),
//       isSeen: json['isSeen'] as bool? ?? false,
//       mediaUrl: json['mediaUrl'] as String?,
//       durationInSeconds: json['durationInSeconds'] as int?,
//       reply: json['reply'] != null
//           ? MessageReplyEntity(
//               messageId: json['reply']['messageId'] as String,
//               text: json['reply']['text'] as String,
//               type: json['reply']['type'] as String,
//               isMe: json['reply']['isMe'] as bool? ?? false,
//             )
//           : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'chatId': chatId,
//       'senderId': senderId,
//       'text': text,
//       'type': type,
//       'createdAt': createdAt.toIso8601String(),
//       'isSeen': isSeen,
//       'mediaUrl': mediaUrl,
//       'durationInSeconds': durationInSeconds,
//       'reply': reply != null
//           ? {
//               'messageId': reply!.messageId,
//               'text': reply!.text,
//               'type': reply!.type,
//               'isMe': reply!.isMe,
//             }
//           : null,
//     };
//   }
// }


// lib/features/chat/data/remote/chat_remote_data_source_impl.dart
// // lib/features/chat/data/remote/chat_remote_data_source_impl.dart

// import 'package:dio/dio.dart';
// import '../../../../core/network/api_client.dart';
// import '../../../../core/network/api_endpoints.dart';
// import '../models/chat_model.dart';
// import '../models/message_model.dart';
// import 'chat_remote_data_source.dart';

// class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
//   final ApiClient _client;

//   ChatRemoteDataSourceImpl(this._client);

//   @override
//   Future<List<ChatModel>> getMyChats() async {
//     final response = await _client.getRequest<List<dynamic>>(
//       ApiEndpoints.chats,
//     );

//     final list = response.data ?? [];
//     return list
//         .map((e) => ChatModel.fromJson(e as Map<String, dynamic>))
//         .toList();
//   }

//   @override
//   Future<List<MessageModel>> getMessages(String chatId) async {
//     final response = await _client.getRequest<List<dynamic>>(
//       ApiEndpoints.chatMessages(chatId),
//     );

//     final list = response.data ?? [];
//     return list
//         .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
//         .toList();
//   }

//   @override
//   Future<MessageModel> sendMessage({
//     required String chatId,
//     required MessageModel message,
//   }) async {
//     final response = await _client.postRequest<Map<String, dynamic>>(
//       ApiEndpoints.chatMessages(chatId),
//       data: message.toJson(),
//     );
//     return MessageModel.fromJson(response.data!);
//   }

//   @override
//   Future<void> deleteMessage({
//     required String chatId,
//     required String messageId,
//   }) async {
//     await _client.deleteRequest<void>(
//       ApiEndpoints.singleMessage(chatId, messageId),
//     );
//   }

//   @override
//   Future<void> deleteMyChat(String chatId) async {
//     await _client.deleteRequest<void>(
//       '${ApiEndpoints.chats}/$chatId',
//     );
//   }

//   @override
//   Future<void> markMessageSeen({
//     required String chatId,
//     required String messageId,
//   }) async {
//     await _client.postRequest<void>(
//       '${ApiEndpoints.singleMessage(chatId, messageId)}/seen',
//     );
//   }
// }


// lib/features/chat/chat_injection_container.dart
// // lib/features/chat/chat_injection_container.dart

// import 'package:get_it/get_it.dart';

// import '../../core/network/api_client.dart';
// import 'data/remote/chat_remote_data_source.dart';
// import 'data/remote/chat_remote_data_source_impl.dart';
// import 'data/repository/chat_repository_impl.dart';
// import 'domain/repository/chat_repository.dart';
// import 'domain/usecases/delete_message_usecase.dart';
// import 'domain/usecases/delete_my_chat_usecase.dart';
// import 'domain/usecases/get_messages_usecase.dart';
// import 'domain/usecases/get_my_chat_usecase.dart';
// import 'domain/usecases/seen_message_update_usecase.dart';
// import 'domain/usecases/send_message_usecase.dart';
// import 'presentation/cubit/chat/chat_cubit.dart';
// import 'presentation/cubit/message/message_cubit.dart';

// final sl = GetIt.instance;

// void initChatFeature() {
//   // Data source
//   sl.registerLazySingleton<ChatRemoteDataSource>(
//     () => ChatRemoteDataSourceImpl(sl<ApiClient>()),
//   );

//   // Repository
//   sl.registerLazySingleton<ChatRepository>(
//     () => ChatRepositoryImpl(sl<ChatRemoteDataSource>()),
//   );

//   // Use cases
//   sl.registerLazySingleton(() => GetMyChatUseCase(sl<ChatRepository>()));
//   sl.registerLazySingleton(() => GetMessagesUseCase(sl<ChatRepository>()));
//   sl.registerLazySingleton(() => SendMessageUseCase(sl<ChatRepository>()));
//   sl.registerLazySingleton(() => DeleteMessageUseCase(sl<ChatRepository>()));
//   sl.registerLazySingleton(() => DeleteMyChatUseCase(sl<ChatRepository>()));
//   sl.registerLazySingleton(
//       () => SeenMessageUpdateUseCase(sl<ChatRepository>()));

//   // Cubits
//   sl.registerFactory(
//     () => ChatCubit(
//       getMyChatUseCase: sl(),
//     ),
//   );

//   sl.registerFactory(
//     () => MessageCubit(
//       getMessagesUseCase: sl(),
//       sendMessageUseCase: sl(),
//       deleteMessageUseCase: sl(),
//       seenMessageUpdateUseCase: sl(),
//     ),
//   );
// }


// Feature: Status
// lib/features/status/data/models/status_model.dart
// // lib/features/status/data/models/status_model.dart

// import '../../domain/entities/status_entity.dart';
// import '../../domain/entities/status_image_entity.dart';

// class StatusModel extends StatusEntity {
//   const StatusModel({
//     required super.id,
//     required super.userId,
//     required super.username,
//     required super.images,
//     required super.createdAt,
//     super.seenBy,
//   });

//   factory StatusModel.fromJson(Map<String, dynamic> json) {
//     return StatusModel(
//       id: json['id'] as String,
//       userId: json['userId'] as String,
//       username: json['username'] as String,
//       images: (json['images'] as List<dynamic>)
//           .map(
//             (e) => StatusImageEntity(
//               url: e['url'] as String,
//               caption: e['caption'] as String?,
//             ),
//           )
//           .toList(),
//       createdAt: DateTime.parse(json['createdAt'] as String),
//       seenBy: (json['seenBy'] as List<dynamic>?)
//               ?.map((e) => e as String)
//               .toList() ??
//           const [],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'userId': userId,
//       'username': username,
//       'images': images
//           .map((e) => {
//                 'url': e.url,
//                 'caption': e.caption,
//               })
//           .toList(),
//       'createdAt': createdAt.toIso8601String(),
//       'seenBy': seenBy,
//     };
//   }
// }


// lib/features/status/data/remote/status_remote_data_source_impl.dart
// // lib/features/status/data/remote/status_remote_data_source_impl.dart

// import '../../../../core/network/api_client.dart';
// import '../../../../core/network/api_endpoints.dart';
// import '../models/status_model.dart';
// import 'status_remote_data_source.dart';

// class StatusRemoteDataSourceImpl implements StatusRemoteDataSource {
//   final ApiClient _client;

//   StatusRemoteDataSourceImpl(this._client);

//   @override
//   Future<List<StatusModel>> getStatus() async {
//     final response = await _client.getRequest<List<dynamic>>(
//       ApiEndpoints.status,
//     );
//     final list = response.data ?? [];
//     return list
//         .map((e) => StatusModel.fromJson(e as Map<String, dynamic>))
//         .toList();
//   }

//   @override
//   Future<StatusModel?> getMyStatus() async {
//     final response = await _client.getRequest<Map<String, dynamic>>(
//       ApiEndpoints.myStatus,
//     );
//     if (response.data == null || response.data!.isEmpty) return null;
//     return StatusModel.fromJson(response.data!);
//   }

//   @override
//   Future<void> deleteStatus(String statusId) async {
//     await _client.deleteRequest<void>(
//       ApiEndpoints.statusById(statusId),
//     );
//   }

//   @override
//   Future<void> updateStatus(StatusModel status) async {
//     await _client.putRequest<void>(
//       ApiEndpoints.statusById(status.id),
//       data: status.toJson(),
//     );
//   }

//   @override
//   Future<void> updateStatusSeen({
//     required String statusId,
//   }) async {
//     await _client.postRequest<void>(
//       ApiEndpoints.statusSeen(statusId),
//     );
//   }
// }


// Feature: User
// lib/features/user/data/models/user_model.dart
// // lib/features/user/data/models/user_model.dart

// import '../../domain/entities/user_entity.dart';

// class UserModel extends UserEntity {
//   const UserModel({
//     required super.uid,
//     required super.name,
//     required super.email,
//     required super.profileUrl,
//     required super.isOnline,
//     super.lastSeen,
//     super.phoneNumber,
//     super.about,
//   });

//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       uid: json['id'] as String,
//       name: json['name'] as String,
//       email: json['email'] as String? ?? '',
//       profileUrl: json['profileUrl'] as String? ?? '',
//       isOnline: json['isOnline'] as bool? ?? false,
//       lastSeen: json['lastSeen'] != null
//           ? DateTime.parse(json['lastSeen'] as String)
//           : null,
//       phoneNumber: json['phoneNumber'] as String?,
//       about: json['about'] as String?,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': uid,
//       'name': name,
//       'email': email,
//       'profileUrl': profileUrl,
//       'isOnline': isOnline,
//       'lastSeen': lastSeen?.toIso8601String(),
//       'phoneNumber': phoneNumber,
//       'about': about,
//     };
//   }
// }


// lib/features/user/data/models/user_presence_model.dart
// // lib/features/user/data/models/user_presence_model.dart

// import '../../domain/entities/user_entity.dart';

// class UserPresenceModel {
//   final String userId;
//   final bool isOnline;
//   final DateTime? lastSeen;

//   UserPresenceModel({
//     required this.userId,
//     required this.isOnline,
//     this.lastSeen,
//   });

//   factory UserPresenceModel.fromJson(Map<String, dynamic> json) {
//     return UserPresenceModel(
//       userId: json['userId'] as String,
//       isOnline: json['isOnline'] as bool? ?? false,
//       lastSeen: json['lastSeen'] != null
//           ? DateTime.parse(json['lastSeen'] as String)
//           : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'userId': userId,
//       'isOnline': isOnline,
//       'lastSeen': lastSeen?.toIso8601String(),
//     };
//   }
// }


// lib/features/user/data/remote/user_remote_data_source_impl.dart
// // lib/features/user/data/remote/user_remote_data_source_impl.dart

// import '../../../../core/network/api_client.dart';
// import '../../../../core/network/api_endpoints.dart';
// import '../../../../storage/token_storage_provider.dart';
// import '../models/user_model.dart';
// import 'user_remote_data_source.dart';

// class UserRemoteDataSourceImpl implements UserRemoteDataSource {
//   final ApiClient _client;
//   final TokenStorageProvider _tokenStorage;

//   UserRemoteDataSourceImpl(this._client, this._tokenStorage);

//   @override
//   Future<UserModel> login({
//     required String email,
//     required String password,
//   }) async {
//     final response = await _client.postRequest<Map<String, dynamic>>(
//       ApiEndpoints.login,
//       data: {
//         'email': email,
//         'password': password,
//       },
//     );
//     final data = response.data!;
//     final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
//     final accessToken = data['accessToken'] as String;
//     final refreshToken = data['refreshToken'] as String?;
//     await _tokenStorage.saveTokens(
//       accessToken: accessToken,
//       refreshToken: refreshToken,
//     );
//     return user;
//   }

//   @override
//   Future<UserModel> register({
//     required String name,
//     required String email,
//     required String password,
//   }) async {
//     final response = await _client.postRequest<Map<String, dynamic>>(
//       ApiEndpoints.register,
//       data: {
//         'name': name,
//         'email': email,
//         'password': password,
//       },
//     );
//     final data = response.data!;
//     final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
//     final accessToken = data['accessToken'] as String;
//     final refreshToken = data['refreshToken'] as String?;
//     await _tokenStorage.saveTokens(
//       accessToken: accessToken,
//       refreshToken: refreshToken,
//     );
//     return user;
//   }

//   @override
//   Future<void> logout() async {
//     await _client.postRequest<void>(ApiEndpoints.logout);
//     await _tokenStorage.clearTokens();
//   }

//   @override
//   Future<UserModel?> getMyUser() async {
//     final response = await _client.getRequest<Map<String, dynamic>>(
//       ApiEndpoints.me,
//     );
//     if (response.data == null || response.data!.isEmpty) return null;
//     return UserModel.fromJson(response.data!);
//   }

//   @override
//   Future<UserModel> getUserById(String userId) async {
//     final response = await _client.getRequest<Map<String, dynamic>>(
//       ApiEndpoints.userById(userId),
//     );
//     return UserModel.fromJson(response.data!);
//   }

//   @override
//   Future<List<UserModel>> getAllUsers() async {
//     final response = await _client.getRequest<List<dynamic>>(
//       ApiEndpoints.users,
//     );
//     final list = response.data ?? [];
//     return list
//         .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
//         .toList();
//   }

//   @override
//   Future<List<UserModel>> searchUsers(String query) async {
//     final response = await _client.getRequest<List<dynamic>>(
//       ApiEndpoints.userSearch,
//       queryParameters: {'q': query},
//     );
//     final list = response.data ?? [];
//     return list
//         .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
//         .toList();
//   }

//   @override
//   Future<void> updateUser(UserModel user) async {
//     await _client.putRequest<void>(
//       ApiEndpoints.userById(user.uid),
//       data: user.toJson(),
//     );
//   }
// }


// lib/features/user/user_injection_container.dart
// // lib/features/user/user_injection_container.dart

// import 'package:get_it/get_it.dart';

// import '../../core/network/api_client.dart';
// import '../../storage/token_storage_provider.dart';
// import 'data/remote/user_remote_data_source.dart';
// import 'data/remote/user_remote_data_source_impl.dart';
// import 'data/repository/user_repository_impl.dart';
// import 'domain/repository/user_repository.dart';
// import 'domain/usecases/get_all_users_usecase.dart';
// import 'domain/usecases/get_my_user_usecase.dart';
// import 'domain/usecases/get_user_by_id_usecase.dart';
// import 'domain/usecases/search_users_usecase.dart';
// import 'domain/usecases/sign_out_usecase.dart';
// import 'domain/usecases/update_user_usecase.dart';
// import 'presentation/cubit/auth/auth_cubit.dart';
// import 'presentation/cubit/user/user_cubit.dart';

// final sl = GetIt.instance;

// void initUserFeature() {
//   // Data source
//   sl.registerLazySingleton<UserRemoteDataSource>(
//     () => UserRemoteDataSourceImpl(
//       sl<ApiClient>(),
//       sl<TokenStorageProvider>(),
//     ),
//   );

//   // Repository
//   sl.registerLazySingleton<UserRepository>(
//     () => UserRepositoryImpl(sl<UserRemoteDataSource>()),
//   );

//   // Use cases
//   sl.registerLazySingleton(() => GetAllUsersUseCase(sl<UserRepository>()));
//   sl.registerLazySingleton(() => GetMyUserUseCase(sl<UserRepository>()));
//   sl.registerLazySingleton(() => GetUserByIdUseCase(sl<UserRepository>()));
//   sl.registerLazySingleton(() => SearchUsersUseCase(sl<UserRepository>()));
//   sl.registerLazySingleton(() => SignOutUseCase(sl<UserRepository>()));
//   sl.registerLazySingleton(() => UpdateUserUseCase(sl<UserRepository>()));

//   // Cubits
//   sl.registerFactory(
//     () => AuthCubit(
//       getMyUserUseCase: sl(),
//       signOutUseCase: sl(),
//     ),
//   );

//   sl.registerFactory(
//     () => UserCubit(
//       getAllUsersUseCase: sl(),
//       searchUsersUseCase: sl(),
//       getUserByIdUseCase: sl(),
//       updateUserUseCase: sl(),
//     ),
//   );
// }


// lib/main_injection_container.dart
// // lib/main_injection_container.dart

// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:get_it/get_it.dart';

// import 'core/network/api_client.dart';
// import 'core/network/api_interceptors.dart';
// import 'core/network/network_info.dart';
// import 'core/utils/logger.dart';
// import 'features/call/call_injection_container.dart';
// import 'features/chat/chat_injection_container.dart';
// import 'features/status/status_injection_container.dart'; // you’ll create this
// import 'features/user/user_injection_container.dart';
// import 'storage/secure_storage_provider.dart';
// import 'storage/token_storage_provider.dart';

// final sl = GetIt.instance;

// Future<void> initDependencies() async {
//   // Core
//   sl.registerLazySingleton<Logger>(() => AppLogger());

//   sl.registerLazySingleton<Connectivity>(() => Connectivity());

//   sl.registerLazySingleton<NetworkInfo>(
//     () => NetworkInfoImpl(sl<Connectivity>()),
//   );

//   sl.registerLazySingleton<Dio>(() {
//     final dio = Dio();
//     return dio;
//   });

//   // Storage
//   sl.registerLazySingleton<FlutterSecureStorage>(
//     () => const FlutterSecureStorage(),
//   );

//   sl.registerLazySingleton<SecureStorageProvider>(
//     () => SecureStorageProviderImpl(sl<FlutterSecureStorage>()),
//   );

//   sl.registerLazySingleton<TokenStorageProvider>(
//     () => TokenStorageProviderImpl(sl<SecureStorageProvider>()),
//   );

//   // Api client
//   sl.registerLazySingleton<ApiClient>(
//     () {
//       final dio = sl<Dio>();
//       final logger = sl<Logger>();
//       final tokenStorage = sl<TokenStorageProvider>();

//       dio.interceptors.addAll([
//         AuthInterceptor(tokenStorage),
//         LoggingInterceptor(logger),
//       ]);

//       return ApiClient(
//         dio,
//         sl<NetworkInfo>(),
//       );
//     },
//   );

//   // Features
//   initUserFeature();
//   initChatFeature();
//   initCallFeature();
//   initStatusFeature(); // you’ll define this in status folder
// }


// lib/main.dart
// // lib/main.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'core/config/environment.dart';
// import 'core/config/flavor_config.dart';
// import 'features/app/theme/style.dart';
// import 'features/app/welcome/welcome_page.dart';
// import 'features/user/presentation/cubit/auth/auth_cubit.dart';
// import 'main_injection_container.dart' as di;

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Initialize flavor config
//   FlavorConfig.init(
//     environment: Environment.dev,
//     baseApiUrl: 'https://api.your-backend.com', // TODO: change per env
//   );

//   await di.initDependencies();

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<AuthCubit>(
//           create: (_) => di.sl<AuthCubit>()..appStarted(),
//         ),
//         // Add more global cubits here if needed
//       ],
//       child: MaterialApp(
//         title: 'WhatsApp Clone',
//         debugShowCheckedModeBanner: false,
//         theme: appTheme(),
//         home: const WelcomePage(),
//         // routes: use your existing on_generate_routes.dart
//       ),
//     );
//   }
// }


