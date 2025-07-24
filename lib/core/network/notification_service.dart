import 'package:dio/dio.dart';
import 'package:venure/app/constant/api/api_endpoints.dart';

class NotificationService {
  late final Dio _dio;

  Future<Response> getNotifications() async {
    return await _dio.get(ApiEndpoints.getNotifications);
  }

  Future<Response> markAsRead(String id) async {
    return await _dio.patch(ApiEndpoints.markNotificationAsRead(id));
  }

  Future<Response> markAllAsRead() async {
    return await _dio.patch(ApiEndpoints.markAllNotificationsAsRead);
  }
}
