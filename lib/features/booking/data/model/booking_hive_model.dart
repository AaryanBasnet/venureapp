import 'dart:convert';

import 'package:hive/hive.dart';

import '../../domain/entity/booking.dart';

part 'booking_hive_model.g.dart';

@HiveType(typeId: 3)
class BookingHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String venue;

  @HiveField(2)
  final DateTime bookingDate;

  @HiveField(3)
  final String timeSlot;

  @HiveField(4)
  final int hoursBooked;

  @HiveField(5)
  final int numberOfGuests;

  @HiveField(6)
  final String eventType;

  @HiveField(7)
  final String specialRequirements;

  @HiveField(8)
  final String contactName;

  @HiveField(9)
  final String phoneNumber;

  // Store addons as JSON encoded strings list
  @HiveField(10)
  final List<String> selectedAddonsJson;

  @HiveField(11)
  final int totalPrice;

  // Store paymentDetails as JSON encoded string
  @HiveField(12)
  final String paymentDetailsJson;

  @HiveField(13)
  final String status;

  @HiveField(14)
  final String customer;

  BookingHiveModel({
    required this.id,
    required this.venue,

    required this.bookingDate,
    required this.timeSlot,
    required this.hoursBooked,
    required this.numberOfGuests,
    required this.eventType,
    this.specialRequirements = '',
    required this.contactName,
    required this.phoneNumber,
    required this.selectedAddonsJson,
    required this.totalPrice,
    required this.paymentDetailsJson,
    this.status = 'booked',
    required this.customer,
  });

  factory BookingHiveModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> addonsDynamic = json['selectedAddons'] ?? [];
    List<String> addonsJson =
        addonsDynamic
            .map((e) => e is Map ? jsonEncode(e) : e.toString())
            .toList();

    final venueId =
        json['venue'] is String
            ? json['venue']
            : (json['venue'] != null ? json['venue']['_id'] : '');

    return BookingHiveModel(
      id: json['_id'] ?? '',
      venue: venueId.toString(),
      bookingDate: DateTime.parse(json['bookingDate']),
      timeSlot: json['timeSlot'],
      hoursBooked: json['hoursBooked'],
      numberOfGuests: json['numberOfGuests'],
      eventType: json['eventType'],
      specialRequirements: json['specialRequirements'] ?? '',
      contactName: json['contactName'],
      phoneNumber: json['phoneNumber'],
      selectedAddonsJson: addonsJson,
      totalPrice: json['totalPrice'],
      paymentDetailsJson: jsonEncode(json['paymentDetails'] ?? {}),
      status: json['status'] ?? 'booked',
      customer: json['customer']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'venue': venue,
      'bookingDate': bookingDate.toIso8601String(),
      'timeSlot': timeSlot,
      'hoursBooked': hoursBooked,
      'numberOfGuests': numberOfGuests,
      'eventType': eventType,
      'specialRequirements': specialRequirements,
      'contactName': contactName,
      'phoneNumber': phoneNumber,
      'selectedAddons': selectedAddonsJson.map((e) => jsonDecode(e)).toList(),
      'totalPrice': totalPrice,
      'paymentDetails': jsonDecode(paymentDetailsJson),
      'status': status,
      'customer': customer,
    };
  }

  // Helpers to convert between decoded JSON and encoded fields:

  List<Map<String, dynamic>> get selectedAddons =>
      selectedAddonsJson
          .map((jsonStr) => jsonDecode(jsonStr) as Map<String, dynamic>)
          .toList();

  Map<String, dynamic> get paymentDetails =>
      jsonDecode(paymentDetailsJson) as Map<String, dynamic>;
}

// Extensions outside class body:

extension BookingHiveModelX on BookingHiveModel {
  Booking toEntity() => Booking(
    id: id,
    venue: venue,
    bookingDate: bookingDate,
    timeSlot: timeSlot,
    hoursBooked: hoursBooked,
    numberOfGuests: numberOfGuests,
    eventType: eventType,
    specialRequirements: specialRequirements,
    contactName: contactName,
    phoneNumber: phoneNumber,
    selectedAddons: selectedAddons,
    totalPrice: totalPrice,
    paymentDetails: paymentDetails,
    status: status,
    customer: customer,
  );
}

extension BookingX on Booking {
  BookingHiveModel toHiveModel() => BookingHiveModel(
    id: id,
    venue: venue,
    bookingDate: bookingDate,
    timeSlot: timeSlot,
    hoursBooked: hoursBooked,
    numberOfGuests: numberOfGuests,
    eventType: eventType,
    specialRequirements: specialRequirements,
    contactName: contactName,
    phoneNumber: phoneNumber,
    selectedAddonsJson: selectedAddons.map((e) => jsonEncode(e)).toList(),
    totalPrice: totalPrice,
    paymentDetailsJson: jsonEncode(paymentDetails),
    status: status,
    customer: customer,
  );
}
