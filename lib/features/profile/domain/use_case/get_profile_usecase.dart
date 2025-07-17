import 'package:dartz/dartz.dart';
import 'package:venure/app/use_case/usecase.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/profile/domain/entity/user_profile_entity.dart';
import 'package:venure/features/profile/domain/repository/profile_repository.dart';

class GetProfileUseCase implements UseCaseWithParams<UserProfileEntity, String> {
  final IProfileRepository repository;

  GetProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserProfileEntity>> call(String token) {
    return repository.getUserProfile(token);
  }
}
