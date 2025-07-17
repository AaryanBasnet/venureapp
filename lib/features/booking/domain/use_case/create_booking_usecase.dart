import 'package:dartz/dartz.dart';
import 'package:venure/app/use_case/usecase.dart';
import 'package:venure/core/error/failure.dart';
import '../entity/booking.dart';
import '../repository/booking_repository.dart';

class CreateBookingUseCase implements UseCaseWithParams<Booking, Booking> {
  final BookingRepository repository;

  CreateBookingUseCase(this.repository);

  @override
  Future<Either<Failure, Booking>> call(Booking booking) async {
    try {
      final createdBooking = await repository.createBooking(booking);
      if (createdBooking != null) {
        return Right(createdBooking);
      } else {
        return Left(ApiFailure(message: "Failed to create booking"));
      }
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
