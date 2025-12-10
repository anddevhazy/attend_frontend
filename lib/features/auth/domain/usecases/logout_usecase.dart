import 'package:dartz/dartz.dart';
import 'package:whatsapp_clone/core/error/failures.dart';
import 'package:whatsapp_clone/core/usecases/usecase.dart';
import 'package:whatsapp_clone/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase implements UseCase<Unit, NoParams> {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return await repository.logout();
  }
}
