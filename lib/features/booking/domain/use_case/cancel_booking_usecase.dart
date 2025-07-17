import 'package:dartz/dartz.dart';
import 'package:venure/app/use_case/usecase.dart';
import 'package:venure/core/error/failure.dart';
import '../repository/booking_repository.dart';

class CancelBookingUseCase implements UseCaseWithParams<bool, String> {
  final BookingRepository repository;

  CancelBookingUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(String bookingId) async {
    try {
      final success = await repository.cancelBooking(bookingId);
      return Right(success);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
