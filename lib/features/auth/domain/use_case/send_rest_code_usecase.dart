import 'package:dartz/dartz.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/auth/domain/repository/user_repository.dart';

class SendResetCodeUseCase {
  final IUserRepository repository;

  SendResetCodeUseCase(this.repository);

  Future<Either<Failure, void>> call(String email) {
    return repository.sendResetCode(email);
  }
}
