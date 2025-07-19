import 'package:venure/features/profile/domain/entity/my_booking_entity.dart';

import '../entity/booking.dart';

abstract class BookingRepository {
  Future<List<MyBooking>> getMyBookings();
  Future<Booking?> createBooking(Booking booking);
  Future<bool> cancelBooking(String bookingId);
}
