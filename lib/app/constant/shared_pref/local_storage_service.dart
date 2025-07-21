import 'package:shared_preferences/shared_preferences.dart';
import 'package:venure/features/auth/domain/entity/user_entity.dart';

class LocalStorageService {
  final SharedPreferences _prefs;

  String? _token;
  String? _userId;

  LocalStorageService(this._prefs) {
    _token = _prefs.getString('token');
    _userId = _prefs.getString('userId');
  }

  static Future<LocalStorageService> getInstance() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageService(prefs);
  }

  Future<void> saveUser(UserEntity user) async {
    await _prefs.setString('token', user.token);
    await _prefs.setString('userId', user.userId ?? "");
    await _prefs.setString('name', user.name);
    await _prefs.setString('email', user.email);
    await _prefs.setString('role', user.role);

    // ✅ Update in-memory cache
    _token = user.token;
    _userId = user.userId;
  }

  // ✅ Getters use in-memory cache first
  String? get token => _token;
  String? get userId => _userId;
  String? get name => _prefs.getString('name');
  String? get email => _prefs.getString('email');
  String? get role => _prefs.getString('role');

  bool get isLoggedIn => _token != null;

  Future<void> clearLoginData() async {
    await _prefs.remove('token');
    await _prefs.remove('userId');
    await _prefs.remove('name');
    await _prefs.remove('email');
    await _prefs.remove('role');

    _token = null;
    _userId = null;
  }
}
