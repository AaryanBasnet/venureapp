import 'package:dartz/dartz.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/auth/data/data_source/local_data_source/user_local_datasource.dart';
import 'package:venure/features/auth/domain/entity/user_entity.dart';
import 'package:venure/features/auth/domain/repository/user_repository.dart';

class UserLocalRepository implements IUserRepository {
  final UserLocalDatasource _userLocalDataSource;

  UserLocalRepository({required UserLocalDatasource userLocalDataSource})
    : _userLocalDataSource = userLocalDataSource;

  @override
  Future<Either<Failure, UserEntity>> loginUser(
    String email,
    String password,
  ) async {
    try {
      final loginResponse = await _userLocalDataSource.loginUser(
        email,
        password,
      );

      final Map<String, dynamic> userData = loginResponse['userData'];
      userData['token'] = loginResponse['token']; // ✅ Now token exists

      final userEntity = UserEntity.fromJson(userData);

      return Right(userEntity);
    } catch (e) {
      return Left(LocalDataBaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) async {
    try {
      await _userLocalDataSource.registerUser(user);
      return Right(null);
    } catch (e) {
      return Left(LocalDataBaseFailure(message: "Registration Failed: $e"));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyPassword(
    String userId,
    String password,
  ) async {
    try {
      final user = _userLocalDataSource.getUserProfile(userId);
      if (user != null && user.password == password) {
        return Right(true);
      }
      return Right(false);
    } catch (e) {
      return Left(LocalDataBaseFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> saveUser(UserEntity user) async {
  try {
    await _userLocalDataSource.saveUser(user);
    return Right(null);
  } catch (e) {
    return Left(LocalDataBaseFailure(message: "Save Failed: $e"));
  }
}

}
