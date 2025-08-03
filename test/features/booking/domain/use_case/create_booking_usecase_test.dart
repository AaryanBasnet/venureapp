import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/booking/domain/entity/booking.dart';
import 'package:venure/features/booking/domain/repository/booking_repository.dart';
import 'package:venure/features/booking/domain/use_case/create_booking_usecase.dart';

// Mock class for BookingRepository
class MockBookingRepository extends Mock implements BookingRepository {}

void main() {
  late CreateBookingUseCase useCase;
  late MockBookingRepository mockRepository;

  final tBooking = Booking(
    id: '1',
    venue: 'venue123',
    customer: 'user123',
    bookingDate: DateTime(2025, 8, 2),
    timeSlot: '10:00 AM - 12:00 PM',

    eventType: 'Wedding',

    hoursBooked: 10,
    numberOfGuests: 10,
    contactName: '',
    phoneNumber: '',
    selectedAddons: [],
    totalPrice: 101,
    paymentDetails: {},
  );

  setUp(() {
    mockRepository = MockBookingRepository();
    useCase = CreateBookingUseCase(mockRepository);
  });

  group('CreateBookingUseCase', () {
    test(
      'should return Right(Booking) when booking creation is successful',
      () async {
        // Arrange
        when(
          () => mockRepository.createBooking(tBooking),
        ).thenAnswer((_) async => tBooking);

        // Act
        final result = await useCase.call(tBooking);

        // Assert
        expect(result, Right(tBooking));
        verify(() => mockRepository.createBooking(tBooking)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return Left(ApiFailure) when repository returns null',
      () async {
        // Arrange
        when(
          () => mockRepository.createBooking(tBooking),
        ).thenAnswer((_) async => null);

        // Act
        final result = await useCase.call(tBooking);

        // Assert
        expect(result, isA<Left<Failure, Booking>>());
        result.fold(
          (failure) => expect(failure, isA<ApiFailure>()),
          (_) => fail('Expected Left but got Right'),
        );
        verify(() => mockRepository.createBooking(tBooking)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return Left(ApiFailure) when repository throws exception',
      () async {
        // Arrange
        final exceptionMessage = 'Database error';
        when(
          () => mockRepository.createBooking(tBooking),
        ).thenThrow(Exception(exceptionMessage));

        // Act
        final result = await useCase.call(tBooking);

        // Assert
        expect(result, isA<Left<Failure, Booking>>());
        result.fold(
          (failure) => expect(failure.message, contains(exceptionMessage)),
          (_) => fail('Expected Left but got Right'),
        );
        verify(() => mockRepository.createBooking(tBooking)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
