import 'package:venure/features/profile/data/model/user_profile_model.dart';
import 'package:venure/features/profile/data/repository/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<Map<String, dynamic>> call(String token) {
    return repository.getUserProfile(token);
  }
}
