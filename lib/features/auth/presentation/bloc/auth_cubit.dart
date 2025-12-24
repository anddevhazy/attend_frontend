import 'package:attend/features/auth/domain/usecases/student_sign_up_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final StudentSignUpUsecase studentSignUpUsecase;

  AuthCubit({required this.studentSignUpUsecase}) : super(Initial());

  Future<void> studentSignUp({
    required String email,
    required String password,
  }) async {
    emit(Loading());

    final result = await studentSignUpUsecase.call(email, password);

    result.fold(
      (leftSideOfStudentSignUpRemoteImpl) {
        emit(Failed(message: leftSideOfStudentSignUpRemoteImpl.message));
      },
      (rightSideOfStudentSignUpRemoteImpl) {
        final emailSent = rightSideOfStudentSignUpRemoteImpl['emailSent'];

        if (emailSent) {
          emit(
            Successful(message: 'Account created & verification email sent'),
          );
        } else {
          emit(
            Successful(
              message:
                  'Account created, but sending verification email failed. Try logging in to resend.',
            ),
          );
        }
      },
    );
  }
}
