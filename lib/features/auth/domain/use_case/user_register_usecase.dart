import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:venure/app/use_case/usecase.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/auth/domain/entity/user_entity.dart';
import 'package:venure/features/auth/domain/repository/user_repository.dart';

class RegisterUserParams extends Equatable {
  final String name;
  final String email;
  final String phone;
  final String password;

  const RegisterUserParams({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  const RegisterUserParams.initial({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, phone, password];
}

class UserRegisterUsecase
    implements UseCaseWithParams<void, RegisterUserParams> {
  final IUserRepository repository;

  UserRegisterUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(RegisterUserParams params) async {
    var user = UserEntity(
      name: params.name,

      email: params.email,
      phone: params.phone,
      password: params.password,
      token: '',
      role: '',
    );
    return await repository.registerUser(user);
  }
}
