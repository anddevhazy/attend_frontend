import 'package:attend/features/auth/domain/usecases/continue_with_google_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'lecturer_history_state.dart';

class LecturerHistoryCubit extends Cubit<LecturerHistoryState> {
  final ContinueWithGoogleUseCase studentSignUpUsecase;

  LecturerHistoryCubit({required this.studentSignUpUsecase}) : super(Initial());

  Future<void> studentSignUp({
    required String email,
    required String password,
  }) async {
    emit(FetchingSessions());
  }
}
