import 'package:dartz/dartz.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/auth/domain/entity/user_entity.dart';

abstract class IUserRepository {
  Future<Either<Failure, UserEntity>> loginUser(String email, String password);
  Future<Either<Failure, void>> registerUser(UserEntity user);
  Future<Either<Failure, bool>> verifyPassword(String userId, String password);

  // 🔐 Forgot Password Flow
  Future<Either<Failure, void>> sendResetCode(String email);
  Future<Either<Failure, void>> verifyResetCode(String email, String code);
  Future<Either<Failure, void>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });
}
