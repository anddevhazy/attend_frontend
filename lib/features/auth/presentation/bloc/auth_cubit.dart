import 'package:attend/features/auth/domain/entities/student_entity.dart';
import 'package:attend/features/auth/domain/usecases/student_sign_up_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final StudentSignUpUsecase studentSignUpUsecase;

  AuthCubit({required this.studentSignUpUsecase}) : super(Initial());

  Future<void> studentSignUp({required StudentEntity student}) async {
    try {
      await studentSignUpUsecase.call(student);
      emit(Successful());
    } catch (_) {
      emit(Failed());
    }
  }

  // Future<void> loggedOut() async{
  //   try{
  //     await signOutUseCase.call();
  //     emit(UnAuthenticated());
  //   }catch(_){
  //     emit(UnAuthenticated());
  //   }
  // }
}
