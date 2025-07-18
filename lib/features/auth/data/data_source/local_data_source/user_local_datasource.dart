import 'package:venure/core/network/hive_service.dart';
import 'package:venure/features/auth/data/data_source/user_data_source.dart';
import 'package:venure/features/auth/data/model/user_hive_model.dart';
import 'package:venure/features/auth/domain/entity/user_entity.dart';

class UserLocalDatasource implements IUserDataSource {
  final HiveService _hiveService;

  UserLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;
@override
Future<Map<String, dynamic>> loginUser(String email, String password) async {
  try {
    final loginUser = await _hiveService.loginUser(email, password);

    if (loginUser != null && loginUser.password == password) {
      return {
        // "token": "local_dummy_token_${loginUser.id}", // optional mock
        "userData": {
          // "id": loginUser.id,
          "name": loginUser.name,
          "email": loginUser.email,
          // "role": loginUser.role,
        }
      };
    } else {
      throw Exception("Invalid Credentials");
    }
  } catch (e) {
    throw Exception("Login Failed: $e");
  }
}

  @override
  Future<void> registerUser(UserEntity user) async {
    try {
      final userHiveModel = UserHiveModel.fromEntity(user);
      await _hiveService.registerUser(userHiveModel);
    } catch (e) {
      throw Exception("Registration failed: $e");
    }
  }
}
