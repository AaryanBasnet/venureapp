import 'package:venure/features/booking/domain/entity/booking.dart';
import 'package:venure/features/home/domain/entity/venue_entity.dart';

class MyBooking {
  final String id;
  final Venue venue;           // full Venue entity
  final DateTime bookingDate;
  final String timeSlot;
  final String status;
  final int totalPrice;

  MyBooking({
    required this.id,
    required this.venue,
    required this.bookingDate,
    required this.timeSlot,
    required this.status,
    required this.totalPrice,
  });

  factory MyBooking.fromBookingAndVenue(Booking booking, Venue venue) {
    return MyBooking(
      id: booking.id,
      venue: venue,
      bookingDate: booking.bookingDate,
      timeSlot: booking.timeSlot,
      status: booking.status,
      totalPrice: booking.totalPrice,
    );
  }
}
