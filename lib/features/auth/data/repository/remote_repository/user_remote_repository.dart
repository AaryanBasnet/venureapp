import 'package:dartz/dartz.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/auth/data/data_source/remote_data_source/user_remote_data_source.dart';
import 'package:venure/features/auth/domain/entity/user_entity.dart';
import 'package:venure/features/auth/domain/repository/user_repository.dart';

class UserRemoteRepository implements IUserRepository {
  final UserRemoteDataSource _userRemoteDataSource;

  UserRemoteRepository({required UserRemoteDataSource userRemoteDataSource})
    : _userRemoteDataSource = userRemoteDataSource;

  @override
  Future<Either<Failure, UserEntity>> loginUser(
    String email,
    String password,
  ) async {
    try {
      final loginResponse = await _userRemoteDataSource.loginUser(email, password);
      // loginResponse is Map<String, dynamic> (raw JSON), convert to UserEntity
      final userEntity = UserEntity.fromJson(loginResponse);
      return Right(userEntity);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) async {
    try {
      await _userRemoteDataSource.registerUser(user);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
