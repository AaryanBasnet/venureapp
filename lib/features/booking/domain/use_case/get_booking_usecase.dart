import 'package:dartz/dartz.dart';
import 'package:venure/app/use_case/usecase.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/profile/domain/entity/my_booking_entity.dart';
import '../repository/booking_repository.dart';


class GetMyBookingsUseCase implements UseCaseWithoutParams<List<MyBooking>> {
  final BookingRepository repository;

  GetMyBookingsUseCase(this.repository);

  @override
  Future<Either<Failure, List<MyBooking>>> call() async {
    try {
      final myBookings = await repository.getMyBookings(); // returns List<MyBooking>
      return Right(myBookings);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
