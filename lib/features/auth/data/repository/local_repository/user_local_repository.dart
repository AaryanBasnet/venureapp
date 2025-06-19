import 'package:dartz/dartz.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/auth/data/data_source/local_data_source/user_local_datasource.dart';
import 'package:venure/features/auth/domain/entity/user_entity.dart';
import 'package:venure/features/auth/domain/repository/user_repository.dart';

class UserLocalRepository implements IUserRepository {
  final UserLocalDatasource _userLocalDataSource;

  UserLocalRepository({required UserLocalDatasource userLocalDataSource})
    : _userLocalDataSource = userLocalDataSource;
  // @override
  // Future<Either<Failure, String>> loginUser(
  //   String email,
  //   String password,
  // ) async {
  //   try {
  //     final result = await _userLocalDataSource.loginUser(email, password);
  //     return Right(result);
  //   } catch (e) {
  //     return Left(LocalDatabaseFailure(message: "Login Failed: $e"));
  //   }
  // }

  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) async {
    try {
      await _userLocalDataSource.registerUser(user);
      return Right(null);
    } catch (e) {
      return Left(LocalDataBaseFailure(message: "Registration Failed: $e"));
    }
  }
}