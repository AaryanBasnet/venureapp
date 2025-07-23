import 'package:dartz/dartz.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/auth/domain/repository/user_repository.dart';

class VerifyResetCodeUseCase {
  final IUserRepository repository;

  VerifyResetCodeUseCase(this.repository);

  Future<Either<Failure, void>> call(String email, String code) {
    return repository.verifyResetCode(email, code);
  }
}
