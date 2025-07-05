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
Future<Map<String, dynamic>> loginUser(String email, String password) async {
  try {
    final response = await _apiService.dio.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      // Full JSON body like: { success, message, token, userData }
      final Map<String, dynamic> responseData = response.data;

      // Optionally validate structure
      if (responseData.containsKey('token') && responseData.containsKey('userData')) {
        return responseData;
      } else {
        throw Exception('Missing token or userData in response');
      }
    } else {
      throw Exception('Login failed: ${response.statusMessage}');
    }
  } on DioException catch (e) {
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        
        return;
      } else {
        throw Exception('Failed to register: ${response.statusMessage ?? 'Unknown error'}');
      }
    } on DioException catch (e) {
 
      throw Exception('Failed to register: ${e.response?.data?['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }
}