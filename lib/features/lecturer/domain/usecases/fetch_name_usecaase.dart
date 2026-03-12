import 'package:attend/features/lecturer/domain/repositories/session_repository.dart';

class FetchNameUsecaase {
  final SessionRepository repository;

  FetchNameUsecaase({required this.repository});

  Future<String> call() async {
    return await repository.fetchName();
  }
}
