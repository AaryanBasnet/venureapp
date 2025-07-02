import 'package:dio/dio.dart';
import 'package:venure/app/constant/api/api_endpoints.dart';
import 'package:venure/core/network/api_service.dart';
import 'package:venure/features/auth/data/data_source/user_data_source.dart';
import 'package:venure/features/auth/data/model/user_api_model.dart';
import 'package:venure/features/auth/domain/entity/user_entity.dart';

class UserRemoteDataSource implements IUserDataSource {
  final ApiService _apiService;

  UserRemoteDataSource({required ApiService apiService})
      : _apiService = apiService;

  @override
  Future<String> loginUser(String email, String password) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final str = response.data['token'];
        return str;
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      // You might want to parse e.response.data for server-specific error messages
      throw Exception('Failed to login: ${e.response?.data?['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  @override
  Future<void> registerUser(UserEntity userData) async {
    try {
      final userApiModel = UserApiModel.fromEntity(userData);

      final response = await _apiService.dio.post(
        ApiEndpoints.register,
        data: userApiModel.toJson(),
      );

      // --- CHANGE IS HERE ---
      if (response.statusCode == 200 || response.statusCode == 201) {
        // You might also want to return some data here, e.g., the user ID
        // if your UI needs it immediately after registration, but Future<void> is fine for just completion.
        return;
      } else {
        // If the status code is neither 200 nor 201, it's still an error
        throw Exception('Failed to register: ${response.statusMessage ?? 'Unknown error'}');
      }
    } on DioException catch (e) {
      // It's good practice to try and get the specific error message from the backend
      // for better user feedback.
      throw Exception('Failed to register: ${e.response?.data?['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }
}