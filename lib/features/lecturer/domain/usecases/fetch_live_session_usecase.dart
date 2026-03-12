import 'package:attend/features/lecturer/domain/entities/session_entity.dart';
import 'package:attend/features/lecturer/domain/repositories/session_repository.dart';

class FetchLiveSessionUsecase {
  final SessionRepository repository;

  FetchLiveSessionUsecase({required this.repository});

  Future<SessionEntity?> call() async {
    return await repository.fetchLiveSession();
  }
}
