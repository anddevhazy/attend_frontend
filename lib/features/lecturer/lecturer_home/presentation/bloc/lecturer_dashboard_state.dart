part of 'lecturer_dashboard_cubit.dart';

abstract class LecturerDashboardState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Initial extends LecturerDashboardState {
  @override
  List<Object> get props => [];
}

class FetchingSession extends LecturerDashboardState {
  @override
  List<Object> get props => [];
}

class Successful extends LecturerDashboardState {
  final String message;

  Successful({required this.message});

  @override
  List<Object?> get props => [message];
}

class Failed extends LecturerDashboardState {
  final String message;

  Failed({required this.message});

  @override
  List<Object> get props => [message];
}
