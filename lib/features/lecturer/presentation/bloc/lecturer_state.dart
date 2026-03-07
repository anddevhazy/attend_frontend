part of 'lecturer_cubit.dart';

abstract class LecturerState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Initial extends LecturerState {
  @override
  List<Object> get props => [];
}

class Loading extends LecturerState {
  @override
  List<Object> get props => [];
}

class Successful extends LecturerState {
  final String message;

  Successful({required this.message});

  @override
  List<Object?> get props => [message];
}

class LiveSessionFetched extends LecturerState {
  final SessionEntity session;

  LiveSessionFetched({required this.session});

  @override
  List<Object?> get props => [session];
}

class NumberOfPastSessionsFetched extends LecturerState {
  final int count;

  NumberOfPastSessionsFetched({required this.count});

  @override
  List<Object?> get props => [count];
}

class PastSessionsFetched extends LecturerState {
  final List<SessionEntity> sessions;

  PastSessionsFetched({required this.sessions});

  @override
  List<Object?> get props => [sessions];
}

class Failed extends LecturerState {
  final String message;

  Failed({required this.message});

  @override
  List<Object> get props => [message];
}
