import 'package:shared_preferences/shared_preferences.dart';

Future<void> storeLoginData(Map<String, dynamic> json) async {
  final prefs = await SharedPreferences.getInstance();

  final token = json['token'];
  final userData = json['userData'];

  await prefs.setString('token', token);
  await prefs.setString('userId', userData['id']);
  await prefs.setString('name', userData['name']);
  await prefs.setString('email', userData['email']);
  await prefs.setString('role', userData['role']);
}
