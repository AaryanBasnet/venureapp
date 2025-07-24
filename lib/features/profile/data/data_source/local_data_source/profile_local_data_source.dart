import 'package:flutter/material.dart';
import 'package:venure/core/network/hive_service.dart';
import 'package:venure/features/profile/data/model/user_profile_model.dart';
import 'package:hive/hive.dart';

class ProfileLocalDataSource {
  final HiveService _hiveService;

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

    await _userBox.put(user.id, user);
  }

  Future<UserProfileModel> getCachedUserProfile() async {
    debugPrint(
      "📦 Attempting to load from Hive. Box isEmpty: ${_userBox.isEmpty}",
    );

    if (_userBox.isEmpty) {
      throw Exception("No cached user profile");
    }

    final user = _userBox.values.first;
    debugPrint("📤 Loaded cached profile: ${user.name} (ID: ${user.id})");

    return user;
  }
}
