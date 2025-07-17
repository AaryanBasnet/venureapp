import 'package:equatable/equatable.dart';

class UserProfileModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String avatar;

  const UserProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.avatar,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name, email, phone, address, avatar];
}
