import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:venure/app/constant/api/api_endpoints.dart';
import 'package:venure/core/network/api_service.dart';

class ProfileRemoteDataSource {
  final ApiService _apiService;

  ProfileRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  Future<Map<String, dynamic>> getUserProfile(String token) async {
    try {
      final response = await _apiService.dio.get(
        ApiEndpoints.getUserProfile,
        options: Options(
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data; // Expects { success, user: {...} }
      } else {
        throw Exception('Failed to load profile: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception(
        'Profile fetch error: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }

  Future<void> updateUserProfile({
    required String token,
    required String name,
    required String phone,
    required String address,
    File? avatarFile,
  }) async {
    try {
      Map<String, dynamic> data = {
        'name': name,
        'phone': phone,
        'address': address,
      };

      if (avatarFile != null) {
        final mimeType =
            lookupMimeType(avatarFile.path) ?? 'application/octet-stream';
        final mimeParts = mimeType.split('/');

        data['profileImage'] = await MultipartFile.fromFile(
          avatarFile.path,
          contentType: MediaType(mimeParts[0], mimeParts[1]),
        );
      }

      final formData = FormData.fromMap(data);

      final response = await _apiService.dio.put(
        ApiEndpoints.updateUserProfile,
        data: formData,
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Profile update failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception(
        'Profile update error: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }
}
