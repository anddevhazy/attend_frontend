import 'package:attend/features/auth/auth_injection_container.dart';
import 'package:attend/service_locator.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'core/network/api_client.dart';
import 'core/network/api_interceptors.dart';
import 'core/network/network_info.dart';

Future<void> init() async {
  // * CORE

  // Connectivity & Network info
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

  // Dio HTTP client
  sl.registerLazySingleton<Dio>(() => Dio());

  // ApiClient with interceptors
  sl.registerLazySingleton<ApiClient>(() {
    final dio = sl<Dio>();

    dio.interceptors.addAll([AuthInterceptor()]);

    return ApiClient(dio, sl<NetworkInfo>());
  });

  // * FEATURES

  await authInjectionContainer();
}
