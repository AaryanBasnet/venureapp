import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:venure/app/use_case/usecase.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/auth/domain/repository/user_repository.dart';

class VerifyPasswordParams extends Equatable {
  final String userId;
  final String password;

  const VerifyPasswordParams({required this.userId, required this.password});

  @override
  List<Object?> get props => [userId, password];
}

class VerifyPasswordUsecase
    implements UseCaseWithParams<bool, VerifyPasswordParams> {
  final IUserRepository repository;

  VerifyPasswordUsecase(this.repository);

  @override
  Future<Either<Failure, bool>> call(VerifyPasswordParams params) {
    return repository.verifyPassword(params.userId, params.password);
  }
}
