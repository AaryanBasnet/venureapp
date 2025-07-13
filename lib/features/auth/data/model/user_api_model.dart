import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:venure/features/auth/domain/entity/user_entity.dart';

part 'user_api_model.g.dart';

@JsonSerializable()
class UserApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? userId;
  final String name;
  final String email;
  final String phone;
  final String password;
  final String token; // add token
  final String role;  // add role

  const UserApiModel({
    this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.token,
    required this.role,
  });

  factory UserApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserApiModelToJson(this);

  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      name: name,
      email: email,
      phone: phone,
      password: password,
      token: token,
      role: role,
    );
  }

  factory UserApiModel.fromEntity(UserEntity userEntity) {
    return UserApiModel(
      userId: userEntity.userId,
      name: userEntity.name,
      email: userEntity.email,
      phone: userEntity.phone,
      password: userEntity.password,
      token: userEntity.token,
      role: userEntity.role,
    );
  }

  @override
  List<Object?> get props => [userId, name, email, phone, password, token, role];
}
