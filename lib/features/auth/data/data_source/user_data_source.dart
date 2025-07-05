import 'package:venure/features/auth/domain/entity/user_entity.dart';

abstract interface class IUserDataSource {
  Future<void> registerUser(UserEntity userData);
Future<Map<String, dynamic>> loginUser(String email, String password);}
