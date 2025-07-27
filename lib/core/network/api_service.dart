import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:venure/app/constant/api/api_endpoints.dart';
import 'package:venure/core/network/dio_error_interceptor.dart';
import 'package:venure/app/constant/shared_pref/local_storage_service.dart';

class ApiService {
  final Dio _dio;

  Dio get dio => _dio;

  ApiService(this._dio) {
    _dio
      ..options.baseUrl = ApiEndpoints.baseUrl
      ..options.connectTimeout = ApiEndpoints.connectionTimeout
      ..options.receiveTimeout = ApiEndpoints.receiveTimeout
      ..interceptors.add(DioErrorInterceptor())
      ..interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
        ),
      );
  }

  Future<Options> _buildOptions({bool requiresAuth = false}) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (requiresAuth) {
      final localStorage = await LocalStorageService.getInstance();
      final token = localStorage.token;
      print("Bearer Token: $token");

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      } else {
        throw Exception('No token found for authenticated request');
      }
    }

    return Options(headers: headers);
  }

  Future<Response> get(String path, {bool requiresAuth = false}) async {
    return _dio.get(
      path,
      options: await _buildOptions(requiresAuth: requiresAuth),
    );
  }

  Future<Response> post(
    String path,
    dynamic data, {
    bool requiresAuth = false,
  }) async {
    return _dio.post(
      path,
      data: data,
      options: await _buildOptions(requiresAuth: requiresAuth),
    );
  }

  Future<Response> put(
    String path,
    dynamic data, {
    bool requiresAuth = false,
  }) async {
    return _dio.put(
      path,
      data: data,
      options: await _buildOptions(requiresAuth: requiresAuth),
    );
  }


  Future<Response> patch(
    String path,
    dynamic data, {
    bool requiresAuth = false,
  }) async {
    return _dio.patch(
      path,
      data: data,
      options: await _buildOptions(requiresAuth: requiresAuth),
    );
  }

  Future<Response> delete(String path, {bool requiresAuth = false}) async {
    return _dio.delete(
      path,
      options: await _buildOptions(requiresAuth: requiresAuth),
    );
  }
}
