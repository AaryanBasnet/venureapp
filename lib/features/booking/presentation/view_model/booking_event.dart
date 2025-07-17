abstract class BookingEvent {}

class BookingNext extends BookingEvent {
  final Map<String, dynamic> data;

  BookingNext(this.data);
}

class BookingBack extends BookingEvent {}

class BookingReset extends BookingEvent {}

class BookingSubmit extends BookingEvent {}
