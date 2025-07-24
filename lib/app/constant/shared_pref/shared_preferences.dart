import 'package:venure/app/constant/shared_pref/local_storage_service.dart';
import 'package:venure/features/auth/domain/entity/user_entity.dart';

Future<void> storeLoginData(Map<String, dynamic> json) async {
  final userData = json['userData'];
  final token = json['token'];

  final user = UserEntity(
    userId: userData['_id'] ?? userData['id'], 
    name: userData['name'],
    email: userData['email'],
    phone: '',      
    password: '',    
    token: token,
    role: userData['role'],
  );

  final localStorage = await LocalStorageService.getInstance();
  print('UserEntity userId: ${user.userId}');
  await localStorage.saveUser(user);
    print('Stored userId: ${localStorage.userId}');

}
