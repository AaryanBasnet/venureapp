import 'package:dio/dio.dart';
import 'package:venure/app/constant/api/api_endpoints.dart';
import 'package:venure/core/network/api_service.dart';

class NotificationApiService {
  final ApiService _apiService;

  NotificationApiService(this._apiService);

  Future<Response> getNotifications() async {
    return await _apiService.get(
      ApiEndpoints.getNotifications,
      requiresAuth: true,
    );
  }

  Future<Response> markAsRead(String id) async {
    return await _apiService.patch(
      ApiEndpoints.markNotificationAsRead(id),
      null,
      requiresAuth: true,
    );
  }

  Future<Response> markAllAsRead() async {
    return await _apiService.patch(
      ApiEndpoints.markAllNotificationsAsRead,
      null,
      requiresAuth: true,
    );
  }
}
