import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/booking/domain/repository/booking_repository.dart';
import 'package:venure/features/booking/domain/use_case/cancel_booking_usecase.dart';

// Mock BookingRepository
class MockBookingRepository extends Mock implements BookingRepository {}

void main() {
  late CancelBookingUseCase useCase;
  late MockBookingRepository mockRepository;

  const tBookingId = 'booking123';

  setUp(() {
    mockRepository = MockBookingRepository();
    useCase = CancelBookingUseCase(mockRepository);
  });

  group('CancelBookingUseCase', () {
    test('should return Right(true) when cancellation is successful', () async {
      // Arrange
      when(() => mockRepository.cancelBooking(tBookingId))
          .thenAnswer((_) async => true);

      // Act
      final result = await useCase.call(tBookingId);

      // Assert
      expect(result, const Right(true));
      verify(() => mockRepository.cancelBooking(tBookingId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Right(false) when cancellation fails (e.g., booking not found)', () async {
      // Arrange
      when(() => mockRepository.cancelBooking(tBookingId))
          .thenAnswer((_) async => false);

      // Act
      final result = await useCase.call(tBookingId);

      // Assert
      expect(result, const Right(false));
      verify(() => mockRepository.cancelBooking(tBookingId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Left(ApiFailure) when repository throws exception', () async {
      // Arrange
      const exceptionMessage = 'Database error';
      when(() => mockRepository.cancelBooking(tBookingId))
          .thenThrow(Exception(exceptionMessage));

      // Act
      final result = await useCase.call(tBookingId);

      // Assert
      expect(result, isA<Left<Failure, bool>>());
      result.fold(
        (failure) {
          expect(failure, isA<ApiFailure>());
          expect(failure.message, contains(exceptionMessage));
        },
        (_) => fail('Expected Left but got Right'),
      );
      verify(() => mockRepository.cancelBooking(tBookingId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
