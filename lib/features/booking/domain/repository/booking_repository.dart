import '../entity/booking.dart';

abstract class BookingRepository {
  Future<List<Booking>> getBookings();
  Future<Booking?> createBooking(Booking booking);
  Future<bool> cancelBooking(String bookingId);
}
