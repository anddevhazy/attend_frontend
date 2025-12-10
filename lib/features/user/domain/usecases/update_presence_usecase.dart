import 'package:dartz/dartz.dart';
import 'package:whatsapp_clone/core/error/failures.dart';
import 'package:whatsapp_clone/core/usecases/usecase.dart';
import 'package:whatsapp_clone/features/user/domain/repositories/user_repository.dart';

class UpdatePresenceUseCase implements UseCase<Unit, bool> {
  final UserRepository repository;
  UpdatePresenceUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(bool isOnline) =>
      repository.updatePresence(isOnline);
}
