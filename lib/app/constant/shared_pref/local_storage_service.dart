import 'package:shared_preferences/shared_preferences.dart';
import 'package:venure/features/auth/domain/entity/user_entity.dart';

class LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  // Factory init method
  static Future<LocalStorageService> getInstance() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageService(prefs);
  }

  // Save login data from UserEntity
  Future<void> saveUser(UserEntity user) async {
    await _prefs.setString('token', user.token);
    await _prefs.setString('userId', user.userId ?? "");
    await _prefs.setString('name', user.name);
    await _prefs.setString('email', user.email);
    await _prefs.setString('role', user.role);
  }

  // Getters
  String? get token => _prefs.getString('token');
  String? get userId => _prefs.getString('userId');
  String? get name => _prefs.getString('name');
  String? get email => _prefs.getString('email');
  String? get role => _prefs.getString('role');

  // Clear
  Future<void> clearLoginData() async {
    await _prefs.remove('token');
    await _prefs.remove('userId');
    await _prefs.remove('name');
    await _prefs.remove('email');
    await _prefs.remove('role');
  }

  bool get isLoggedIn => _prefs.containsKey('token');
}
