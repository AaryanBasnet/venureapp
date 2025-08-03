import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:venure/features/profile/data/model/user_profile_model.dart';
import 'package:venure/core/network/hive_service.dart';

class ProfileLocalDataSource {
  final HiveService _hiveService;

  static const String cachedUserKey = 'cached_user';

  ProfileLocalDataSource({required HiveService hiveService})
    : _hiveService = hiveService;

  Box<UserProfileModel> get _userBox => _hiveService.userProfileBox;

  Future<void> cacheUserProfile(UserProfileModel user) async {
    debugPrint("✅ About to cache profile:");
    debugPrint("  → ID: ${user.id}");
    debugPrint("  → Name: ${user.name}");
    debugPrint("  → Email: ${user.email}");
    debugPrint("  → Phone: ${user.phone}");
    debugPrint("  → Address: ${user.address}");
    debugPrint("  → Avatar: ${user.avatar}");

    if (user.id.isEmpty || user.name.isEmpty) {
      throw Exception("🛑 Refused to cache invalid user profile.");
    }

    debugPrint("📦 Saving to Hive box: ${_userBox.name}");
    debugPrint("  → Box isEmpty: ${_userBox.isEmpty}");
    debugPrint("  → Box length before save: ${_userBox.length}");

    await _userBox.put(cachedUserKey, user);
    debugPrint("✅ Cached user profile under key: '$cachedUserKey'");
  }

  Future<UserProfileModel> getCachedUserProfile() async {
    debugPrint("📦 Attempting to load from Hive with key '$cachedUserKey'.");
    debugPrint("  → Box isEmpty: ${_userBox.isEmpty}");

    final user = _userBox.get(cachedUserKey);

    if (user == null || user.id.isEmpty || user.name.isEmpty) {
      throw Exception("❌ Cached user profile is invalid or missing.");
    }

    debugPrint("📤 Loaded cached profile: ${user.name} (ID: ${user.id})");

    return user;
  }

  /// Optional: If you want to wipe old corrupted entries once
  Future<void> clearAllUserProfiles() async {
    debugPrint("🧹 Clearing all user profile entries...");
    await _userBox.clear();
  }
}
