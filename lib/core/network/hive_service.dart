import 'dart:ffi';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:venure/app/constant/hive/hive_table_constant.dart';
import 'package:venure/features/auth/data/model/user_hive_model.dart';

class HiveService {
  Future<void> init() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = '${directory.path}venure.db';

    Hive.init(path);

    Hive.registerAdapter(UserHiveModelAdapter());
  }

  //register user
  Future<void> registerUser(UserHiveModel user) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);

    var newUser = box.put(user.userId, user);

    return newUser;
  }

  //login user
  Future<UserHiveModel?> loginUser(String email, String password) async {
    var box = await Hive.openBox(HiveTableConstant.userBox);
    var user = box.values.firstWhere(
      (u) => u.email == email && u.password == password,
      orElse: () => throw Exception('Invalid credentials'),
    );
    box.close();
    return user;
  }
}
