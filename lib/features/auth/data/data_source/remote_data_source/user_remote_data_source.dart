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
        if (responseData.containsKey('token') &&
            responseData.containsKey('userData')) {
          return responseData;
        } else {
          throw Exception('Missing token or userData in response');
        }
      } else {
        throw Exception('Login failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception(
        'Failed to login: ${e.response?.data?['message'] ?? e.message}',
      );
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
        throw Exception(
          'Failed to register: ${response.statusMessage ?? 'Unknown error'}',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        'Failed to register: ${e.response?.data?['message'] ?? e.message}',
      );
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }

  @override
  Future<bool> verifyPassword(String userId, String password) async {
    try {
      final response = await _apiService.dio.post(
        '/auth/verify-password',
        data: {'userId': userId, 'password': password},
      );

      if (response.statusCode == 200) {
        return response.data['success'] == true;
      } else {
        throw Exception('Verification failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception(
        'Failed to verify password: ${e.response?.data?['message'] ?? e.message}',
      );
    }
  }
  @override
Future<void> sendResetCode(String email) async {
  try {
    final response = await _apiService.dio.post(
      ApiEndpoints.forgotPassword, // "/auth/forgot-password"
      data: {'email': email},
    );

    if (response.statusCode != 200) {
      throw Exception(response.data['message'] ?? 'Failed to send reset code');
    }
  } on DioException catch (e) {
    throw Exception(
      'Failed to send reset code: ${e.response?.data?['message'] ?? e.message}',
    );
  }
}

@override
Future<void> verifyResetCode(String email, String code) async {
  try {
    final response = await _apiService.dio.post(
      ApiEndpoints.verifyResetCode, // "/auth/verify-reset-code"
      data: {
        'email': email,
        'code': code,
      },
    );

    if (response.statusCode != 200) {
      throw Exception(response.data['message'] ?? 'Invalid or expired code');
    }
  } on DioException catch (e) {
    throw Exception(
      'Failed to verify code: ${e.response?.data?['message'] ?? e.message}',
    );
  }
}

@override
Future<void> resetPassword({
  required String email,
  required String code,
  required String newPassword,
}) async {
  try {
    final response = await _apiService.dio.post(
      ApiEndpoints.resetPassword, // "/auth/reset-password"
      data: {
        'email': email,
        'code': code,
        'password': newPassword,
      },
    );

    if (response.statusCode != 200) {
      throw Exception(response.data['message'] ?? 'Failed to reset password');
    }
  } on DioException catch (e) {
    throw Exception(
      'Failed to reset password: ${e.response?.data?['message'] ?? e.message}',
    );
  }
}
}
