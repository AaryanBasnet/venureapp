import 'dart:io';
import 'package:venure/features/profile/data/data_source/remote_data_source/profile_remote_data_source.dart';
import 'package:venure/features/profile/data/model/user_profile_model.dart';

class ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepository({required this.remoteDataSource});

  Future<Map<String, dynamic>> getUserProfile(String token) {
    return remoteDataSource.getUserProfile(token);
  }

  Future<void> updateUserProfile({
    required String token,
    required String name,
    required String phone,
    required String address,
    File? avatarFile,
  }) {
    return remoteDataSource.updateUserProfile(
      token: token,
      name: name,
      phone: phone,
      address: address,
      avatarFile: avatarFile,
    );
  }
}
