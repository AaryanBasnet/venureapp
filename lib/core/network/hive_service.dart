import 'dart:ffi';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
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
}
