import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:venure/app/use_case/usecase.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/auth/domain/repository/user_repository.dart';

class LoginUserParams extends Equatable {
  final String email;
  final String password;

  const LoginUserParams({required this.email, required this.password});

  const LoginUserParams.initial() : email = '', password = '';

  @override
  List<Object?> get props => [email, password];
}

class UserLoginUsecase implements UseCaseWithParams<Map<String, dynamic>, LoginUserParams> {
  final IUserRepository repository;

  UserLoginUsecase({required this.repository});

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(LoginUserParams params) async {
    return await repository.loginUser(params.email, params.password);
  }
}