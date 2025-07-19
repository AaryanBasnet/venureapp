abstract class BookingEvent {}

class FetchBookings extends BookingEvent {}

class CancelBooking extends BookingEvent {
  final String bookingId;
  CancelBooking(this.bookingId);
}
