import 'package:dartz/dartz.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/auth/domain/entity/user_entity.dart';

abstract class IUserRepository {
  Future<Either<Failure, Map<String, dynamic>>> loginUser(String email, String password);
  Future<Either<Failure, void>> registerUser(UserEntity user);
}
