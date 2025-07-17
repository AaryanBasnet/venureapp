import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/profile/domain/entity/user_profile_entity.dart';

abstract class IProfileRepository {
  Future<Either<Failure, UserProfileEntity>> getUserProfile(String token);

  Future<Either<Failure, void>> updateUserProfile({
    required String token,
    required String name,
    required String phone,
    required String address,
    File? avatarFile,
  });
}
