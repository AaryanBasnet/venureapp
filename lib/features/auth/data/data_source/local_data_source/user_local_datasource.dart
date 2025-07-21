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

      if (loginUser != null) {
        // Save current userId locally for offline access
        await _hiveService.saveCurrentUserId(loginUser.userId);

        return {
          "userData": {"name": loginUser.name, "email": loginUser.email},
          "token": "dummy_token_${loginUser.userId}", // dummy token for offline
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
      final generatedId = DateTime.now().millisecondsSinceEpoch.toString();

      final userHiveModel = UserHiveModel(
        userId: user.userId ?? generatedId,
        name: user.name,
        email: user.email,
        phone: user.phone,
        password: user.password,
        role: user.role.isNotEmpty ? user.role : 'Customer',
        token:
            user.token.isNotEmpty
                ? user.token
                : 'local_dummy_token_$generatedId',
      );

      await _hiveService.registerUser(userHiveModel);
    } catch (e) {
      throw Exception("Local Registration failed: $e");
    }
  }

  UserHiveModel? getUserProfile(String userId) {
    return _hiveService.getUserProfile(userId);
  }

  Future<void> saveUser(UserEntity user) async {
    try {
      final existingUser = _hiveService.getUserProfile(user.userId ?? '');

      final userHiveModel = UserHiveModel(
        userId: user.userId ?? existingUser?.userId ?? '',
        name: user.name,
        email: user.email,
        phone: user.phone,
        password: user.password,
        role: user.role.isNotEmpty ? user.role : 'Customer',
        token: user.token.isNotEmpty ? user.token : existingUser?.token ?? '',
      );

      await _hiveService.registerUser(userHiveModel);
    } catch (e) {
      throw Exception("Save user failed: $e");
    }
  }

  @override
  Future<void> saveCurrentUserId(String userId) async {
    await _hiveService.saveCurrentUserId(userId);
  }

  @override
  Future<String?> getCurrentUserId() async {
    return await _hiveService.getCurrentUserId();
  }
}
