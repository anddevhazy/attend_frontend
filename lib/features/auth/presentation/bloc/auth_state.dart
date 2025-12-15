part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class Initial extends AuthState {
  @override
  List<Object> get props => [];
}

class Loading extends AuthState {
  @override
  List<Object> get props => [];
}

class Successful extends AuthState {
  @override
  List<Object> get props => [];
}

class Failed extends AuthState {
  @override
  List<Object> get props => [];
}
