import 'dart:io';

class UpdateProfileParams {
  final String token;
  final String name;
  final String phone;
  final String address;
  final File? avatarFile;

  UpdateProfileParams({
    required this.token,
    required this.name,
    required this.phone,
    required this.address,
    this.avatarFile,
  });
}
