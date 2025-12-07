import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'core/network/api_client.dart';
import 'core/network/api_interceptors.dart';
import 'core/network/network_info.dart';
import 'core/utils/logger.dart';
import 'storage/secure_storage_provider.dart';
import 'storage/token_storage_provider.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // * CORE

  // Logger
  sl.registerLazySingleton<Logger>(() => AppLogger());

  // Connectivity & Network info
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl<Connectivity>()),
  );

  // Dio HTTP client
  sl.registerLazySingleton<Dio>(() => Dio());

  // Secure storage
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  sl.registerLazySingleton<SecureStorageProvider>(
    () => SecureStorageProviderImpl(sl<FlutterSecureStorage>()),
  );

  sl.registerLazySingleton<TokenStorageProvider>(
    () => TokenStorageProviderImpl(sl<SecureStorageProvider>()),
  );

  // ApiClient with interceptors
  sl.registerLazySingleton<ApiClient>(() {
    final dio = sl<Dio>();
    final logger = sl<Logger>();
    final tokenStorage = sl<TokenStorageProvider>();

    dio.interceptors.addAll([
      AuthInterceptor(tokenStorage),
      LoggingInterceptor(logger),
    ]);

    return ApiClient(dio, sl<NetworkInfo>());
  });

  // * FEATURES

  await userInjectionContainer();
  await chatInjectionContainer();
  await statusInjectionContainer();
  await callInjectionContainer();
}
