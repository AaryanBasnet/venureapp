import 'dart:io';
import 'package:venure/features/profile/data/repository/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<void> call({
    required String token,
    required String name,
    required String phone,
    required String address,
    File? avatarFile,
  }) {
    return repository.updateUserProfile(
      token: token,
      name: name,
      phone: phone,
      address: address,
      avatarFile: avatarFile,
    );
  }
}
