import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? userId;
  final String name;
  final String email;
  final String phone;
  final String password; // Usually not returned from backend; consider removing from entity if unused
  final String token;
  final String role;

  const UserEntity({
    this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.token,
    required this.role,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      userId: json['_id']?.toString() ?? json['id']?.toString(),
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      password: '', // don't store password from backend response
      token: json['token'] as String? ?? '',
      role: json['role'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': userId,
    'name': name,
    'email': email,
    'phone': phone,
    'token': token,
    'role': role,
  };

  @override
  List<Object?> get props => [
    userId,
    name,
    email,
    phone,
    password,
    token,
    role,
  ];
}
