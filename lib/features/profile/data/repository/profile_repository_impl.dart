import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/profile/data/data_source/local_data_source/profile_local_data_source.dart';
import 'package:venure/features/profile/domain/entity/user_profile_entity.dart';
import 'package:venure/features/profile/domain/repository/profile_repository.dart';
import 'package:venure/features/profile/data/data_source/remote_data_source/profile_remote_data_source.dart';
import 'package:venure/features/profile/data/model/user_profile_model.dart';

class ProfileRepositoryImpl implements IProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserProfileEntity>> getUserProfile(String token) async {
    try {
      final remoteData = await remoteDataSource.getUserProfile(token);
      final userModel = UserProfileModel.fromJson(remoteData);

      // Save to local cache
      await localDataSource.cacheUserProfile(userModel);

      return Right(userModel.toEntity());
    } catch (e) {
      try {
        // Fallback to local
        final localUser = await localDataSource.getCachedUserProfile();
        return Right(localUser.toEntity());
      } catch (_) {
        return Left(ApiFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, void>> updateUserProfile({
    required String token,
    required String name,
    required String phone,
    required String address,
    File? avatarFile,
  }) async {
    try {
      await remoteDataSource.updateUserProfile(
        token: token,
        name: name,
        phone: phone,
        address: address,
        avatarFile: avatarFile,
      );

      // Update local cache too
      final updated = await remoteDataSource.getUserProfile(token);
      final updatedModel = UserProfileModel.fromJson(updated);
      await localDataSource.cacheUserProfile(updatedModel);

      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
