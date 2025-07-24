import 'package:venure/app/constant/api/api_endpoints.dart';
import 'package:venure/core/network/api_service.dart';


class BookingRemoteDataSource {
  final ApiService apiService;

  BookingRemoteDataSource(this.apiService);

  Future<List<Map<String, dynamic>>> fetchBookings() async {
    final response = await apiService.get(ApiEndpoints.getBookingsForCustomer, requiresAuth: true);
    if (response.statusCode == 200 && response.data['success'] == true) {
      return List<Map<String, dynamic>>.from(response.data['data']);
    } else {
      throw Exception('Failed to fetch bookings');
    }
  }

  

  Future<Map<String, dynamic>> createBooking(Map<String, dynamic> bookingJson) async {
    final response = await apiService.post(ApiEndpoints.createBooking, bookingJson, requiresAuth: true);
    if (response.statusCode == 201) {
      return response.data['booking'];
    } else {
      throw Exception('Failed to create booking');
    }
  }

  Future<bool> cancelBooking(String id) async {
    final response = await apiService.put('${ApiEndpoints.cancelBooking}/$id/cancel', {}, requiresAuth: true);
    return response.statusCode == 200;
  }
}
