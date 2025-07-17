import 'package:dartz/dartz.dart';
import 'package:venure/app/use_case/usecase.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/profile/domain/repository/profile_repository.dart';
import 'package:venure/features/profile/domain/use_case/update_profile_params.dart';

class UpdateProfileUseCase
    implements UseCaseWithParams<void, UpdateProfileParams> {
  final IProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateProfileParams params) {
    return repository.updateUserProfile(
      token: params.token,
      name: params.name,
      phone: params.phone,
      address: params.address,
      avatarFile: params.avatarFile,
    );
  }
}
