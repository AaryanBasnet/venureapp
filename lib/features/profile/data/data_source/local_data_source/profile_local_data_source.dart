import 'package:venure/features/profile/data/model/user_profile_model.dart';
import 'package:hive/hive.dart';
import 'package:venure/app/constant/hive/hive_table_constant.dart';

class ProfileLocalDataSource {
  Future<void> cacheUserProfile(UserProfileModel user) async {
    final box = await Hive.openBox<UserProfileModel>(HiveTableConstant.userBox);
    await box.put(user.id, user);
  }

  Future<UserProfileModel> getCachedUserProfile() async {
    final box = await Hive.openBox<UserProfileModel>(HiveTableConstant.userBox);
    if (box.isEmpty) throw Exception("No cached user profile");
    return box.values.first;
  }
}
