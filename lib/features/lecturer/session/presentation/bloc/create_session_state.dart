part of 'create_session_cubit.dart';

abstract class CreateSessionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Initial extends CreateSessionState {
  @override
  List<Object> get props => [];
}

class Loading extends CreateSessionState {
  @override
  List<Object> get props => [];
}

class Successful extends CreateSessionState {
  final String message;

  Successful({required this.message});

  @override
  List<Object?> get props => [message];
}

class LiveSessionFetched extends CreateSessionState {
  final SessionEntity session;

  LiveSessionFetched({required this.session});

  @override
  List<Object?> get props => [session];
}

class NumberOfPastSessionsFetched extends CreateSessionState {
  final int count;

  NumberOfPastSessionsFetched({required this.count});

  @override
  List<Object?> get props => [count];
}

class PastSessionsFetched extends CreateSessionState {
  final List<SessionEntity> sessions;

  PastSessionsFetched({required this.sessions});

  @override
  List<Object?> get props => [sessions];
}

class Failed extends CreateSessionState {
  final String message;

  Failed({required this.message});

  @override
  List<Object> get props => [message];
}
