import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentService {
  static const String baseUrl =
      "http://192.168.1.70:5050/api"; // Your backend base URL
  Future<Map<String, dynamic>> createPaymentIntent({
  required int amount,
  required String venueId,
  required String bookingDate,
  required String timeSlot,
  required String token,
}) async {
  final url = Uri.parse('$baseUrl/payment/create-payment-intent');
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'amount': amount,
      'venueId': venueId,
      'bookingDate': bookingDate,
      'timeSlot': timeSlot,
    }),
  );

  if (response.statusCode == 200) {
    final body = jsonDecode(response.body);
    return {
      'clientSecret': body['clientSecret'],
      'paymentIntentId': body['paymentIntentId'], // 👈
    };
  } else {
    throw Exception('Failed to create payment intent');
  }
}
}