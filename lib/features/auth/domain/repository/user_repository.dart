import 'package:dartz/dartz.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/auth/domain/entity/auth_entity.dart';

abstract interface class IUserRepository {

  Future<Either<Failure, void>> registerUser(AuthEntity user);

  

}