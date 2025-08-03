import 'dart:io';


abstract class ProfileEvent {}

class LoadUserProfile extends ProfileEvent {}

class UpdateUserProfile extends ProfileEvent {
  final String name;
  final String phone;
  final String address;
  final File? avatarFile;

  UpdateUserProfile({
    required this.name,
    required this.phone,
    required this.address,
    this.avatarFile,
  });
}

class LogoutUser extends ProfileEvent {}

