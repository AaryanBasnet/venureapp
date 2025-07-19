import 'package:dio/dio.dart';
import 'package:venure/core/network/api_service.dart';
import 'package:venure/app/constant/api/api_endpoints.dart';

class ChatApiService {
  final ApiService apiService;

  ChatApiService({required this.apiService});

  Future<Response> getUserChats({String? venueId}) async {
    String url = ApiEndpoints.getUserChats;

    if (venueId != null) {
      url += "?venueId=$venueId";
    }

    return apiService.get(url, requiresAuth: true);
  }

  Future<Response> getOrCreateChat({
    required String participantId,
    required String venueId,
  }) async {
    final data = {"participantId": participantId, "venueId": venueId};

    return apiService.post(
      ApiEndpoints.getOrCreateChat,
      data,
      requiresAuth: true,
    );
  }
}
