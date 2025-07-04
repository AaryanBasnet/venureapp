import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:venure/app/constant/hive/hive_table_constant.dart';
import 'package:venure/features/auth/domain/entity/user_entity.dart';


 part 'user_hive_model.g.dart';
@HiveType(typeId: HiveTableConstant.userTableId)
class UserHiveModel extends Equatable {
  @HiveField(0)
  final String? userId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String phone;

  @HiveField(4)
  final String password;

   UserHiveModel({
   String? userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  }) : userId = userId ?? Uuid().v4();

  const UserHiveModel.initial()
   : userId = '',
   name ='',
   email = '',
   phone = '',
   password = '';

   factory UserHiveModel.fromEntity(UserEntity userEntity) {
    return UserHiveModel(name: userEntity.name, email: userEntity.email, phone: userEntity.phone, password: userEntity.password);
   }

   UserEntity toEntity() {
    return UserEntity(userId: userId, name: name, email: email, phone: phone, password: password);
   }

   static List<UserHiveModel> fromEntityList(List<UserEntity> userEntityList) {
    return userEntityList
    .map((userEntity) => UserHiveModel.fromEntity(userEntity))
    .toList();
   }
   
     @override
     // TODO: implement props
     List<Object?> get props => [userId, name, email, phone, password];


}
