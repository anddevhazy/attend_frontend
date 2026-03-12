import 'package:attend/features/lecturer/domain/repositories/session_repository.dart';

class FetchNumberOfPastSessionsUsecase {
  final SessionRepository repository;

  FetchNumberOfPastSessionsUsecase({required this.repository});

  Future<int> call() async {
    return await repository.fetchNumberOfPastSessions();
  }
}
