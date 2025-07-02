import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:venure/features/auth/domain/entity/user_entity.dart';

part 'user_api_model.g.dart';

@JsonSerializable()
class UserApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? userId;
  final String fullName;
  final String email;
  final String phone;
  final String password;

  const UserApiModel({
    this.userId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
  });

  factory UserApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserApiModelToJson(this);

  UserEntity toEntity() {
    return UserEntity(
      userId: userId,

      fullName: fullName,

      email: email,

      phone: phone,

      password: password,
    );
  }

  factory UserApiModel.fromEntity(UserEntity userEntity) {
    final user = UserApiModel(
      fullName: userEntity.fullName,

      phone: userEntity.phone,

      email: userEntity.email,

      password: userEntity.password,
    );

    return user;
  }

  @override
  List<Object?> get props => [userId, fullName, phone, email, password];
}
