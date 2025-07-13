import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:venure/app/constant/shared_pref/local_storage_service.dart';
import 'package:venure/app/use_case/usecase.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/auth/domain/entity/user_entity.dart';
import 'package:venure/features/auth/domain/repository/user_repository.dart';

class LoginUserParams extends Equatable {
  final String email;
  final String password;

  const LoginUserParams({required this.email, required this.password});

  const LoginUserParams.initial() : email = '', password = '';

  @override
  List<Object?> get props => [email, password];
}
class UserLoginUsecase implements UseCaseWithParams<UserEntity, LoginUserParams> {
  final IUserRepository _repository;
  final LocalStorageService _localStorageService;

  UserLoginUsecase({
    required IUserRepository repository,
    required LocalStorageService localStorageService,
  })  : _repository = repository,
        _localStorageService = localStorageService;

  @override
  Future<Either<Failure, UserEntity>> call(LoginUserParams params) async {
    final result = await _repository.loginUser(params.email, params.password);

    return await result.fold(
      (failure) async => Left(failure),
      (userEntity) async {
        await _localStorageService.saveUser(userEntity);
        return Right(userEntity);
      },
    );
  }
}
