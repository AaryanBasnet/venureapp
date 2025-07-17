import 'package:hive/hive.dart';
import 'package:venure/app/constant/hive/hive_table_constant.dart';
import 'package:venure/features/booking/data/model/booking_hive_model.dart';


class BookingLocalDataSource {
  static const String bookingBoxName = HiveTableConstant.bookingsBox;

  Future<void> saveBooking(BookingHiveModel booking) async {
    final box = await Hive.openBox<BookingHiveModel>(bookingBoxName);
    await box.put(booking.id, booking);
  }

  Future<List<BookingHiveModel>> getAllBookings() async {
    final box = await Hive.openBox<BookingHiveModel>(bookingBoxName);
    return box.values.toList();
  }

  Future<BookingHiveModel?> getBookingById(String id) async {
    final box = await Hive.openBox<BookingHiveModel>(bookingBoxName);
    return box.get(id);
  }

  Future<void> clearAllBookings() async {
    final box = await Hive.openBox<BookingHiveModel>(bookingBoxName);
    await box.clear();
  }
}
