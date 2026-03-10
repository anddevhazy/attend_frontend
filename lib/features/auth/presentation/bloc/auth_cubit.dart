import 'dart:async';

import 'package:attend/features/auth/domain/usecases/continue_with_google_usecase.dart';
import 'package:attend/features/auth/domain/usecases/logout_usecase.dart';
import 'package:attend/features/lecturer/domain/entities/lecturer_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final ContinueWithGoogleUseCase continueWithGoogleUseCase;
  final LogoutUseCase logoutUseCase;

  AuthCubit({
    required this.continueWithGoogleUseCase,
    required this.logoutUseCase,
  }) : super(Initial());
  Future<void> continueWithGoogle() async {
    emit(Loading());

    try {
      final result = await continueWithGoogleUseCase.call();

      final lecturer = result.$2;

      emit(Successful(lecturer: lecturer));
    } catch (e) {
      emit(Failed(message: "Google sign-in failed: ${e.toString()}"));
      print(e);
    }
  }

  Future<void> logout() async {
    emit(Loading());

    try {
      await logoutUseCase.call();

      emit(SuccessfullyLoggedOut(message: "Logged out successfully"));
    } catch (e) {
      emit(Failed(message: "Failed to log out: ${e.toString()}"));
    }
  }
}
