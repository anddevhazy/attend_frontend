part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
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
  final String message;

  Successful({required this.message});

  @override
  List<Object?> get props => [message];
}

class Failed extends AuthState {
  final String message;

  Failed({required this.message});

  @override
  List<Object> get props => [message];
}
