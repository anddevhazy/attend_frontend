import 'package:attend/features/lecturer/lecturer_injection_container.dart';
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
import 'package:google_sign_in/google_sign_in.dart';
import 'global/core/network/api_client.dart';
import 'global/core/network/network_info.dart';

Future<void> init() async {
  // api client
  sl.registerLazySingleton<ApiClient>(() {
    return ApiClient(sl<Dio>(), sl<NetworkInfo>());
  });
  //dio
  sl.registerLazySingleton<Dio>(() {
    final dio = Dio();

    dio.interceptors.add(sl<AuthInterceptor>());
    dio.interceptors.add(sl<RefreshTokenInterceptor>());

    return dio;
  });
  //network info
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl<Connectivity>()),
  );
  //connectivity
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  //google sign in
  final googleSignIn = GoogleSignIn.instance;
  sl.registerLazySingleton(() => googleSignIn);

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

  await authInjectionContainer();
  await lecturerInjectionContainer();
}
