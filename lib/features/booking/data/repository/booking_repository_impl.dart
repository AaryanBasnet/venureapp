import 'package:venure/features/booking/data/data_source/local_data_source/local_data_source.dart';
import 'package:venure/features/booking/data/data_source/remote_data_source/remote_data_source.dart';
import 'package:venure/features/booking/domain/entity/booking.dart';
import 'package:venure/features/booking/domain/repository/booking_repository.dart';

import '../model/booking_hive_model.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;
  final BookingLocalDataSource localDataSource;

  BookingRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Booking>> getBookings() async {
    try {
      final remoteData = await remoteDataSource.fetchBookings();
      final bookings =
          remoteData
              .map((json) => BookingHiveModel.fromJson(json).toEntity())
              .toList();

      // Cache locally
      await localDataSource.clearAllBookings();
      for (var booking in bookings) {
        await localDataSource.saveBooking(booking.toHiveModel());
      }

      return bookings;
    } catch (_) {
      // Fallback to local cache on error
      final cached = await localDataSource.getAllBookings();
      return cached.map((e) => e.toEntity()).toList();
    }
  }

  @override
  Future<Booking?> createBooking(Booking booking) async {
    try {
      final json = await remoteDataSource.createBooking(
        booking.toHiveModel().toJson(),
      );
      final newBooking = BookingHiveModel.fromJson(json).toEntity();
      await localDataSource.saveBooking(newBooking.toHiveModel());
      return newBooking;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> cancelBooking(String bookingId) async {
    try {
      final success = await remoteDataSource.cancelBooking(bookingId);
      if (success) {
        final bookingHive = await localDataSource.getBookingById(bookingId);
        if (bookingHive != null) {
          final updatedBooking = bookingHive.toEntity();
          final cancelledBooking = Booking(
            id: updatedBooking.id,
            venue: updatedBooking.venue,
            bookingDate: updatedBooking.bookingDate,
            timeSlot: updatedBooking.timeSlot,
            hoursBooked: updatedBooking.hoursBooked,
            numberOfGuests: updatedBooking.numberOfGuests,
            eventType: updatedBooking.eventType,
            specialRequirements: updatedBooking.specialRequirements,
            contactName: updatedBooking.contactName,
            phoneNumber: updatedBooking.phoneNumber,
            selectedAddons: updatedBooking.selectedAddons,
            totalPrice: updatedBooking.totalPrice,
            paymentDetails: updatedBooking.paymentDetails,
            status: "cancelled",
            customer: updatedBooking.customer,
          );
          await localDataSource.saveBooking(cancelledBooking.toHiveModel());
        }
      }
      return success;
    } catch (_) {
      return false;
    }
  }
}
