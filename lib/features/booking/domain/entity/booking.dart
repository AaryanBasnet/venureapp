class Booking {
  final String id;
  final String customer;        // Add this field
  final String venue;
  final DateTime bookingDate;
  final String timeSlot;
  final int hoursBooked;
  final int numberOfGuests;
  final String eventType;
  final String specialRequirements;
  final String contactName;
  final String phoneNumber;
  final List<Map<String, dynamic>> selectedAddons;
  final int totalPrice;
  final Map<String, dynamic> paymentDetails;
  final String status;

  Booking({
    required this.id,
    required this.customer,      // Require customer in constructor
    required this.venue,
    required this.bookingDate,
    required this.timeSlot,
    required this.hoursBooked,
    required this.numberOfGuests,
    required this.eventType,
    this.specialRequirements = '',
    required this.contactName,
    required this.phoneNumber,
    required this.selectedAddons,
    required this.totalPrice,
    required this.paymentDetails,
    this.status = 'booked',
  });
}
