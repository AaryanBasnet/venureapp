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
    print("Remote login response: $loginResponse");
    
    final Map<String, dynamic> userData = loginResponse['userData'];
    userData['token'] = loginResponse['token'];
    final userEntity = UserEntity.fromJson(userData);
    return Right(userEntity);
  } catch (e, stackTrace) {
    print("Remote login exception: $e");
    print(stackTrace);
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

  @override
  Future<Either<Failure, bool>> verifyPassword(
  String userId,
  String password,
) async {
  try {
    final result = await _userRemoteDataSource.verifyPassword(userId, password);
    return Right(result);
  } catch (e) {
    return Left(ApiFailure(message: e.toString()));
  }
}

}
