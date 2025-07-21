import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? userId;
  final String name;
  final String email;
  final String phone;
  final String password;
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
      password: '', // no password from backend
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

  UserEntity copyWith({
    String? userId,
    String? name,
    String? email,
    String? phone,
    String? password,
    String? token,
    String? role,
  }) {
    return UserEntity(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      token: token ?? this.token,
      role: role ?? this.role,
    );
  }

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
