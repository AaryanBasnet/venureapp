import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/booking/domain/repository/booking_repository.dart';
import 'package:venure/features/booking/domain/use_case/get_booking_usecase.dart';
import 'package:venure/features/home/domain/entity/venue_entity.dart';
import 'package:venure/features/home/domain/entity/venue_image_entity.dart';
import 'package:venure/features/home/domain/entity/venue_location_entity.dart';
import 'package:venure/features/profile/domain/entity/my_booking_entity.dart';

// Mock BookingRepository
class MockBookingRepository extends Mock implements BookingRepository {}

void main() {
  late GetMyBookingsUseCase useCase;
  late MockBookingRepository mockRepository;

  final tVenueLocation = VenueLocation(
    address: '123 Main St',
    city: 'Kathmandu',
    state: 'Bagmati',
    country: 'Nepal',
    
  );

  final tVenueImages = [
    VenueImage(url: 'img1.jpg',  filename: ''),
    VenueImage(url: 'img2.jpg', filename: ''),
  ];

  final tVenue = Venue(
    id: 'venue123',
    ownerId: 'owner123',
    venueName: 'Banquet Hall',
    location: tVenueLocation,
    capacity: 200,
    venueImages: tVenueImages,
    description: 'A beautiful banquet hall.',
    amenities: ['Parking', 'WiFi'],
    pricePerHour: 50000,
    status: 'available',
    isDeleted: false,
    createdAt: DateTime(2025, 1, 1),
    updatedAt: DateTime(2025, 1, 2),
  );

  final tBookings = [
    MyBooking(
      id: '1',
      venue: tVenue,
      bookingDate: DateTime(2025, 8, 2),
      timeSlot: '10:00 AM - 12:00 PM',
      status: 'confirmed',
      totalPrice: 100000,
    ),
    MyBooking(
      id: '2',
      venue: tVenue,
      bookingDate: DateTime(2025, 8, 10),
      timeSlot: '5:00 PM - 8:00 PM',
      status: 'pending',
      totalPrice: 75000,
    ),
  ];

  setUp(() {
    mockRepository = MockBookingRepository();
    useCase = GetMyBookingsUseCase(mockRepository);
  });

  group('GetMyBookingsUseCase', () {
    test('should return Right(List<MyBooking>) when repository call is successful', () async {
      // Arrange
      when(() => mockRepository.getMyBookings())
          .thenAnswer((_) async => tBookings);

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, Right(tBookings));
      verify(() => mockRepository.getMyBookings()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Left(ApiFailure) when repository throws an exception', () async {
      // Arrange
      final exceptionMessage = 'Database error';
      when(() => mockRepository.getMyBookings())
          .thenThrow(Exception(exceptionMessage));

      // Act
      final result = await useCase.call();

      // Assert
      expect(result, isA<Left<Failure, List<MyBooking>>>());
      result.fold(
        (failure) => expect(failure.message, contains(exceptionMessage)),
        (_) => fail('Expected Left but got Right'),
      );
      verify(() => mockRepository.getMyBookings()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
