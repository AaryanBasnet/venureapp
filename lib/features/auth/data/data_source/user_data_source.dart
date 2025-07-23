import 'package:venure/features/auth/domain/entity/user_entity.dart';

abstract interface class IUserDataSource {
  Future<void> registerUser(UserEntity userData);
  Future<Map<String, dynamic>> loginUser(String email, String password);

  // 🔐 Forgot Password Flow
  Future<void> sendResetCode(String email);
  Future<void> verifyResetCode(String email, String code);
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });
}
