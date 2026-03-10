import 'package:attend/features/lecturer/data/data_sources/local/course_local_data_souce.dart';
import 'package:attend/features/lecturer/data/data_sources/local/location_local_data_source.dart';
import 'package:attend/features/lecturer/data/data_sources/remote/session_remote_data_source.dart';
import 'package:attend/features/lecturer/data/data_sources/remote/session_remote_data_source_impl.dart';
import 'package:attend/features/lecturer/data/repository/session_repository_impl.dart';
import 'package:attend/features/lecturer/domain/repositories/session_repository.dart';
import 'package:attend/features/lecturer/domain/usecases/create_session_usecase.dart';
import 'package:attend/features/lecturer/domain/usecases/end_session_usecase.dart';
import 'package:attend/features/lecturer/domain/usecases/fetch_live_session_usecase.dart';
import 'package:attend/features/lecturer/domain/usecases/fetch_number_of_past_sessions_usecase.dart';
import 'package:attend/features/lecturer/domain/usecases/fetch_past_sessions_usecase.dart';
import 'package:attend/features/lecturer/domain/usecases/get_courses_usecase.dart';
import 'package:attend/features/lecturer/domain/usecases/get_locations_usecase.dart';
import 'package:attend/features/lecturer/presentation/bloc/lecturer_cubit.dart';
import 'package:attend/service_locator.dart';

Future<void> lecturerInjectionContainer() async {
  // * CUBITS INJECTION
  sl.registerFactory<LecturerCubit>(
    () => LecturerCubit(
      createSessionUsecase: sl.call(),
      fetchLiveSessionUsecase: sl.call(),
      endSessionUsecase: sl.call(),
      fetchNumberOfPastSessionsUsecase: sl.call(),
      fetchPastSessionsUsecase: sl.call(),
      getCoursesUsecase: sl.call(),
      getLocationsUsecase: sl.call(),
    ),
  );

  // * USE CASES INJECTION
  sl.registerLazySingleton<CreateSessionUsecase>(
    () => CreateSessionUsecase(repository: sl.call()),
  );

  sl.registerLazySingleton<FetchLiveSessionUsecase>(
    () => FetchLiveSessionUsecase(repository: sl.call()),
  );

  sl.registerLazySingleton<EndSessionUsecase>(
    () => EndSessionUsecase(repository: sl.call()),
  );

  sl.registerLazySingleton<FetchNumberOfPastSessionsUsecase>(
    () => FetchNumberOfPastSessionsUsecase(repository: sl.call()),
  );

  sl.registerLazySingleton<FetchPastSessionsUsecase>(
    () => FetchPastSessionsUsecase(repository: sl.call()),
  );

  sl.registerLazySingleton<GetCoursesUsecase>(
    () => GetCoursesUsecase(local: sl.call()),
  );

  sl.registerLazySingleton<GetLocationsUsecase>(
    () => GetLocationsUsecase(local: sl.call()),
  );

  // * REPOSITORY & DATA SOURCES INJECTION
  sl.registerLazySingleton<SessionRepository>(
    () => SessionRepositoryImpl(remoteDataSource: sl.call()),
  );

  sl.registerLazySingleton<SessionRemoteDataSource>(
    () => SessionRemoteDataSourceImpl(client: sl.call()),
  );

  sl.registerLazySingleton<CourseLocalDataSource>(
    () => CourseLocalDataSource(),
  );

  sl.registerLazySingleton<LocationLocalDataSource>(
    () => LocationLocalDataSource(),
  );
}
