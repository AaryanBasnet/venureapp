// data/repository/hybrid_user_repository.dart

import 'package:dartz/dartz.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/auth/data/repository/local_repository/user_local_repository.dart';
import 'package:venure/features/auth/data/repository/remote_repository/user_remote_repository.dart';
import 'package:venure/features/auth/domain/entity/user_entity.dart';
import 'package:venure/features/auth/domain/repository/user_repository.dart';

class HybridUserRepository implements IUserRepository {
  final UserRemoteRepository remote;
  final UserLocalRepository local;

  HybridUserRepository({required this.remote, required this.local});

  @override
Future<Either<Failure, UserEntity>> loginUser(
  String email,
  String password,
) async {
  try {
    final remoteResult = await remote.loginUser(email, password);
    print("Hybrid repo remoteResult: $remoteResult");

    if (remoteResult.isRight()) {
      return await remoteResult.fold((failure) => Left(failure), (
        userEntity,
      ) async {
        final userWithPassword = userEntity.copyWith(password: password);
        
        await local.saveUser(userWithPassword);
        await local.saveCurrentUserId(userWithPassword.userId); // ✅ Save current userId here

        return Right(userWithPassword);
      });
    } else {
      print("Fallback to local login due to remote failure");
      final localResult = await local.loginUser(email, password);
      if (localResult.isRight()) return localResult;
      return remoteResult;
    }
  } catch (e, stackTrace) {
    print("Hybrid repo caught exception: $e");
    print(stackTrace);
    final localResult = await local.loginUser(email, password);
    if (localResult.isRight()) return localResult;
    return Left(ApiFailure(message: e.toString()));
  }
}


  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) async {
    print('Attempting remote registration for user: ${user.email}');
    final remoteResult = await remote.registerUser(user);
    print('Remote registration result: $remoteResult');

    if (remoteResult.isRight()) {
      print('Remote registration succeeded');
      return remoteResult;
    }

    print('Remote registration failed, trying local registration');
    final localResult = await local.registerUser(user);
    print('Local registration result: $localResult');

    if (localResult.isRight()) {
      print('Local registration succeeded');
      return localResult;
    }

    print(
      'Both remote and local registration failed, returning remote failure',
    );
    return remoteResult;
  }

  @override
  Future<Either<Failure, bool>> verifyPassword(
    String userId,
    String password,
  ) async {
    final remoteResult = await remote.verifyPassword(userId, password);

    if (remoteResult.isRight()) {
      return remoteResult;
    }

    final localResult = await local.verifyPassword(userId, password);

    if (localResult.isRight()) {
      return localResult;
    }

    return remoteResult;
  }
}
