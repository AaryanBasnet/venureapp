import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? userId;
  final String name;
  final String email;
  final String phone;
  final String password;

  const UserEntity({
    this.userId,

    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  @override
  List<Object?> get props => [userId, name, email, phone, password];
}
