part of 'lecturer_history_cubit.dart';

abstract class LecturerHistoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Initial extends LecturerHistoryState {
  @override
  List<Object> get props => [];
}

class FetchingSessions extends LecturerHistoryState {
  @override
  List<Object> get props => [];
}

class Successful extends LecturerHistoryState {
  final String message;

  Successful({required this.message});

  @override
  List<Object?> get props => [message];
}

class Failed extends LecturerHistoryState {
  final String message;

  Failed({required this.message});

  @override
  List<Object> get props => [message];
}
