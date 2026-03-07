import 'package:attend/features/auth/data/data_sources/local/auth_local_data_source.dart';
import 'package:attend/features/lecturer/lecturer_injection_container.dart';
import 'package:attend/global/core/interceptors/auth_interceptor.dart';
import 'package:attend/global/core/interceptors/refresh_token_interceptor.dart';
import 'package:attend/features/auth/auth_injection_container.dart';
import 'package:attend/global/storage/token_storage.dart';
import 'package:attend/global/storage/token_storage_impl.dart';
import 'package:attend/service_locator.dart';
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
  // token storage
  sl.registerLazySingleton<TokenStorage>(
    () => TokenStorageImpl(sl<FlutterSecureStorage>()),
  );
  // flutter secure storage
  sl.registerLazySingleton<FlutterSecureStorage>(() => FlutterSecureStorage());

  sl.registerLazySingleton<AuthInterceptor>(
    () => AuthInterceptor(localDataSource: sl<AuthLocalDataSource>()),
  );
  sl.registerLazySingleton<RefreshTokenInterceptor>(
    () => RefreshTokenInterceptor(sl<Dio>(), sl<AuthLocalDataSource>()),
  );
  await authInjectionContainer();
  await lecturerInjectionContainer();
}


// note for me: you create an instance when it's something coming from the outside, like google sign in, dio, connectivity, flutter secure storage. You don't create an instance for your own classes, you just register them.