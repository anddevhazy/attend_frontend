import 'package:attend/features/auth/data/data_sources/local/auth_local_data_source.dart';
import 'package:attend/features/auth/data/data_sources/local/auth_local_data_source_impl.dart';
import 'package:attend/features/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:attend/features/auth/data/data_sources/remote/auth_remote_data_source_impl.dart';
import 'package:attend/features/auth/data/repository/auth_repository_impl.dart';
import 'package:attend/features/auth/domain/repositories/auth_repository.dart';
import 'package:attend/features/auth/domain/usecases/continue_with_google_usecase.dart';
import 'package:attend/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:attend/service_locator.dart';
import 'package:attend/storage/token_storage.dart';

Future<void> authInjectionContainer() async {
  // * CUBITS INJECTION
  sl.registerFactory<AuthCubit>(
    () => AuthCubit(studentSignUpUsecase: sl.call()),
  );

  // * USE CASES INJECTION
  sl.registerLazySingleton<ContinueWithGoogleUseCase>(
    () => ContinueWithGoogleUseCase(repository: sl.call()),
  );

  // sl.registerLazySingleton<LogoutUseCase>(
  //   () => LogoutUseCase(repository: sl.call()),
  // );

  // * REPOSITORY & DATA SOURCES INJECTION
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl.call(),
      localDataSource: sl.call(),
    ),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl.call(), googleSignIn: sl.call()),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl<TokenStorage>()),
  );
}
