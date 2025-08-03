import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/profile/domain/entity/my_booking_entity.dart';
import 'package:venure/features/profile/presentation/view_model/my_bookings_view_model/my_booking_view_model.dart';
import 'package:venure/features/profile/presentation/view_model/my_bookings_view_model/my_bookings_event.dart';
import 'package:venure/features/profile/presentation/view_model/my_bookings_view_model/my_bookings_state.dart';
import 'package:venure/features/booking/domain/use_case/get_booking_usecase.dart';
import 'package:venure/features/booking/domain/use_case/cancel_booking_usecase.dart';
import 'package:venure/features/home/domain/entity/venue_entity.dart';
import 'package:venure/features/home/domain/entity/venue_location_entity.dart';

// Mocks for UseCases
class MockGetMyBookingsUseCase extends Mock implements GetMyBookingsUseCase {}

class MockCancelBookingUseCase extends Mock implements CancelBookingUseCase {}

// Fake for MyBooking to satisfy registerFallbackValue
class FakeMyBookingEntity extends Fake implements MyBooking {}

// Sample VenueLocation for Venue creation
final tVenueLocation = VenueLocation(
  address: '123 Main St',
  city: 'Kathmandu',
  state: 'Bagmati',
  country: 'Nepal',
);

void main() {
  late BookingBloc bookingBloc;
  late MockGetMyBookingsUseCase mockGetBookingsUseCase;
  late MockCancelBookingUseCase mockCancelBookingUseCase;

  // Minimal Venue instance to satisfy MyBooking requirements
  final testVenue = Venue(
    id: 'venue1',
    ownerId: 'owner1',
    venueName: 'Test Venue',
    location: tVenueLocation,
    capacity: 100,
    venueImages: const [],
    description: null,
    amenities: const [],
    pricePerHour: 100.0,
    status: 'active',
    isDeleted: false,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  setUpAll(() {
    registerFallbackValue(FakeMyBookingEntity());
  });

  setUp(() {
    mockGetBookingsUseCase = MockGetMyBookingsUseCase();
    mockCancelBookingUseCase = MockCancelBookingUseCase();

    bookingBloc = BookingBloc(
      getBookingsUseCase: mockGetBookingsUseCase,
      cancelBookingUseCase: mockCancelBookingUseCase,
    );
  });

  test('initial state is BookingInitial', () {
    expect(bookingBloc.state, equals(BookingInitial()));
  });

  group('FetchBookings', () {
    final bookings = [
      MyBooking(
        id: '1',
        venue: testVenue,
        bookingDate: DateTime.now(),
        timeSlot: '10:00-12:00',
        status: 'confirmed',
        totalPrice: 200,
      ),
      MyBooking(
        id: '2',
        venue: testVenue,
        bookingDate: DateTime.now(),
        timeSlot: '14:00-16:00',
        status: 'pending',
        totalPrice: 300,
      ),
    ];

    blocTest<BookingBloc, BookingState>(
      'emits [BookingLoading, BookingLoaded] when fetch is successful',
      build: () {
        when(() => mockGetBookingsUseCase()).thenAnswer((_) async => Right(bookings));
        return bookingBloc;
      },
      act: (bloc) => bloc.add(FetchBookings()),
      expect: () => [
        BookingLoading(),
        BookingLoaded(bookings),
      ],
      verify: (_) {
        verify(() => mockGetBookingsUseCase()).called(1);
      },
    );

    blocTest<BookingBloc, BookingState>(
      'emits [BookingLoading, BookingError] when fetch fails',
      build: () {
        when(() => mockGetBookingsUseCase())
            .thenAnswer((_) async => Left(ApiFailure(message: 'Failed to fetch')));
        return bookingBloc;
      },
      act: (bloc) => bloc.add(FetchBookings()),
      expect: () => [
        BookingLoading(),
        BookingError('Failed to fetch'),
      ],
      verify: (_) {
        verify(() => mockGetBookingsUseCase()).called(1);
      },
    );
  });

  group('CancelBooking', () {
    final bookings = [
      MyBooking(
        id: '1',
        venue: testVenue,
        bookingDate: DateTime.now(),
        timeSlot: '10:00-12:00',
        status: 'confirmed',
        totalPrice: 200,
      ),
      MyBooking(
        id: '2',
        venue: testVenue,
        bookingDate: DateTime.now(),
        timeSlot: '14:00-16:00',
        status: 'pending',
        totalPrice: 300,
      ),
      MyBooking(
        id: '3',
        venue: testVenue,
        bookingDate: DateTime.now(),
        timeSlot: '16:00-18:00',
        status: 'cancelled',
        totalPrice: 150,
      ),
    ];

    blocTest<BookingBloc, BookingState>(
      'emits updated bookings list after cancellation success and refetch',
      build: () {
        when(() => mockCancelBookingUseCase('2'))
            .thenAnswer((_) async => const Right(true));
        when(() => mockGetBookingsUseCase())
            .thenAnswer((_) async => Right(bookings));
        return bookingBloc;
      },
      seed: () => BookingLoaded(bookings),
      act: (bloc) => bloc.add(CancelBooking('2')),
      expect: () => [
        BookingLoaded(bookings.where((b) => b.id != '2').toList()),
        BookingLoading(),  // expected intermediate loading state when refetch triggered
        BookingLoaded(bookings), // final fresh bookings loaded
      ],
      verify: (_) {
        verify(() => mockCancelBookingUseCase('2')).called(1);
        verify(() => mockGetBookingsUseCase()).called(1);
      },
    );

    blocTest<BookingBloc, BookingState>(
      'emits BookingError on cancellation failure and does not refetch',
      build: () {
        when(() => mockCancelBookingUseCase('2'))
            .thenAnswer((_) async => Left(ApiFailure(message: 'Cancel failed')));
        return bookingBloc;
      },
      seed: () => BookingLoaded(bookings),
      act: (bloc) => bloc.add(CancelBooking('2')),
      expect: () => [
        BookingLoaded(bookings.where((b) => b.id != '2').toList()),
        BookingError('Cancel failed'),
      ],
      verify: (_) {
        verify(() => mockCancelBookingUseCase('2')).called(1);
        verifyNever(() => mockGetBookingsUseCase());
      },
    );

    blocTest<BookingBloc, BookingState>(
      'does nothing on CancelBooking if state is not BookingLoaded',
      build: () => bookingBloc,
      act: (bloc) => bloc.add(CancelBooking('2')),
      expect: () => [],
      verify: (_) {
        verifyNever(() => mockCancelBookingUseCase(any()));
      },
    );
  });
}
