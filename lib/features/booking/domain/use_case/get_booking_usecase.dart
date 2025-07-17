import 'package:dartz/dartz.dart';
import 'package:venure/app/use_case/usecase.dart';
import 'package:venure/core/error/failure.dart';
import '../entity/booking.dart';
import '../repository/booking_repository.dart';

class GetBookingsUseCase implements UseCaseWithoutParams<List<Booking>> {
  final BookingRepository repository;

  GetBookingsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Booking>>> call() async {
    try {
      final bookings = await repository.getBookings();
      return Right(bookings);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
