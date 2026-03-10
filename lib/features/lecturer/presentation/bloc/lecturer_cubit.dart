import 'package:attend/features/course/course_entity.dart';
import 'package:attend/features/lecturer/domain/entities/session_entity.dart';
import 'package:attend/features/lecturer/domain/usecases/create_session_usecase.dart';
import 'package:attend/features/lecturer/domain/usecases/end_session_usecase.dart';
import 'package:attend/features/lecturer/domain/usecases/fetch_live_session_usecase.dart';
import 'package:attend/features/lecturer/domain/usecases/fetch_number_of_past_sessions_usecase.dart';
import 'package:attend/features/lecturer/domain/usecases/fetch_past_sessions_usecase.dart';
import 'package:attend/features/lecturer/domain/usecases/get_courses_usecase.dart';
import 'package:attend/features/lecturer/domain/usecases/get_locations_usecase.dart';
import 'package:attend/features/location/location_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'lecturer_state.dart';

class LecturerCubit extends Cubit<LecturerState> {
  final CreateSessionUsecase createSessionUsecase;
  final FetchLiveSessionUsecase fetchLiveSessionUsecase;
  final EndSessionUsecase endSessionUsecase;
  final FetchNumberOfPastSessionsUsecase fetchNumberOfPastSessionsUsecase;
  final FetchPastSessionsUsecase fetchPastSessionsUsecase;
  final GetCoursesUsecase getCoursesUsecase;
  final GetLocationsUsecase getLocationsUsecase;

  LecturerCubit({
    required this.createSessionUsecase,
    required this.fetchLiveSessionUsecase,
    required this.endSessionUsecase,
    required this.fetchNumberOfPastSessionsUsecase,
    required this.fetchPastSessionsUsecase,
    required this.getCoursesUsecase,
    required this.getLocationsUsecase,
  }) : super(Initial());

  Future<void> startSession(SessionEntity sessionEntity) async {
    emit(Loading());

    try {
      await createSessionUsecase.call(sessionEntity);
      emit(Successful(message: "Session started successfully"));
    } catch (e) {
      emit(Failed(message: "Failed to start session: ${e.toString()}"));
      print(e);
    }
  }

  Future<void> fetchLiveSession(String sessionId) async {
    emit(Loading());

    try {
      final liveSession = await fetchLiveSessionUsecase.call(sessionId);
      emit(LiveSessionFetched(session: liveSession));
    } catch (e) {
      emit(Failed(message: "Failed to fetch live session: ${e.toString()}"));
    }
  }

  Future<void> endSession(String sessionId) async {
    emit(Loading());

    try {
      await endSessionUsecase.call(sessionId);
      emit(Successful(message: "Session ended successfully"));
    } catch (e) {
      emit(Failed(message: "Failed to end session: ${e.toString()}"));
    }
  }

  Future<void> fetchNumberOfPastSessions(String lecturerId) async {
    emit(Loading());

    try {
      final count = await fetchNumberOfPastSessionsUsecase.call(lecturerId);

      emit(NumberOfPastSessionsFetched(count: count));
    } catch (e) {
      emit(
        Failed(
          message: "Failed to fetch number of past sessions: ${e.toString()}",
        ),
      );
    }
  }

  Future<void> fetchPastSessions(String lecturerId) async {
    emit(Loading());

    try {
      final sessions = await fetchPastSessionsUsecase.call(lecturerId);

      emit(PastSessionsFetched(sessions: sessions));
    } catch (e) {
      emit(Failed(message: "Failed to fetch past sessions: ${e.toString()}"));
    }
  }

  Future<void> getCourses() async {
    emit(Loading());

    try {
      final courses = await getCoursesUsecase.call();
      emit(CoursesFetched(courses: courses));
    } catch (e) {
      emit(Failed(message: "Failed to fetch courses: ${e.toString()}"));
      rethrow;
    }
  }

  Future<void> getLocations() async {
    emit(Loading());

    try {
      final locations = await getLocationsUsecase.call();
      emit(LocationsFetched(locations: locations));
    } catch (e) {
      emit(Failed(message: "Failed to fetch locations: ${e.toString()}"));
      rethrow;
    }
  }
}
