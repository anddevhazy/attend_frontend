import 'dart:async';

import 'package:attend/features/auth/domain/usecases/continue_with_google_usecase.dart';
import 'package:attend/features/lecturer/lecturer_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final ContinueWithGoogleUseCase continueWithGoogleUseCase;
  final Logout

  AuthCubit({required this.continueWithGoogleUseCase}) : super(Initial());
  Future<void> continueWithGoogle() async {
    emit(Loading());

    try {
      final result = await continueWithGoogleUseCase.call();

      final lecturer = result.$2;

      emit(Successful(lecturer: lecturer));
    } catch (e) {
      emit(Failed(message: "Google sign-in failed: ${e.toString()}"));
    }
  }

  Future<void> logout() async {
    emit(Loading());

    try {
      final result = await continueWithGoogleUseCase.call();

      final lecturer = result.$2;

      emit(Successful(lecturer: lecturer));
    } catch (e) {
      emit(Failed(message: "Google sign-in failed: ${e.toString()}"));
    }
  }
}
