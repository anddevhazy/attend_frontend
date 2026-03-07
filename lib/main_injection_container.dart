import 'package:attend/global/core/interceptors/refresh_token_interceptor.dart';
import 'package:attend/global/core/network/api_interceptors.dart';
import 'package:attend/features/auth/auth_injection_container.dart';
import 'package:attend/features/auth/data/data_sources/local/auth_local_data_source.dart';
import 'package:attend/service_locator.dart';
import 'package:attend/global/storage/token_storage.dart';
import 'package:attend/global/storage/token_storage_impl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'global/core/network/api_client.dart';
import 'global/core/network/network_info.dart';

Future<void> init() async {
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl<Connectivity>()),
  );

  // Note for myself:
  // sl.registerLazySingleton<NetworkInfo>(
  //   () => NetworkInfoImpl(sl<Connectivity>()),
  // );

  // is the same as ;

  //  sl.registerLazySingleton<NetworkInfo>(
  //   () => NetworkInfoImpl(sl.call()),
  // );

  sl.registerLazySingleton<Dio>(() {
    final dio = Dio();

    dio.interceptors.add(sl<AuthInterceptor>());
    dio.interceptors.add(sl<RefreshTokenInterceptor>());

    return dio;
  });

  sl.registerLazySingleton<FlutterSecureStorage>(() => FlutterSecureStorage());

  sl.registerLazySingleton<TokenStorage>(
    () => TokenStorageImpl(sl<FlutterSecureStorage>()),
  );

  sl.registerLazySingleton<AuthInterceptor>(
    () => AuthInterceptor(sl<AuthLocalDataSource>()),
  );

  sl.registerLazySingleton<RefreshTokenInterceptor>(
    () => RefreshTokenInterceptor(sl<Dio>(), sl<AuthLocalDataSource>()),
  );

  sl.registerLazySingleton<ApiClient>(() {
    final dio = sl<Dio>();

    return ApiClient(dio, sl<NetworkInfo>());
  });

  await authInjectionContainer();
}
