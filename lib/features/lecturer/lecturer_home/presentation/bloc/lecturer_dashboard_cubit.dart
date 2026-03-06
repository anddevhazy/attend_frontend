import 'package:attend/features/auth/domain/usecases/continue_with_google_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'lecturer_dashboard_state.dart';

class LecturerDashboardCubit extends Cubit<LecturerDashboardState> {
  final ContinueWithGoogleUseCase studentSignUpUsecase;

  LecturerDashboardCubit({required this.studentSignUpUsecase})
    : super(Initial());

  Future<void> studentSignUp({
    required String email,
    required String password,
  }) async {
    emit(FetchingSession());
  }
}
