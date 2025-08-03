import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:venure/features/home/domain/entity/venue_entity.dart';
import 'package:venure/features/profile/domain/entity/my_booking_entity.dart';
import 'package:venure/features/profile/presentation/view/my_bookings_view/my_bookings_view.dart';
import 'package:venure/features/profile/presentation/view_model/my_bookings_view_model/my_booking_view_model.dart';
import 'package:venure/features/profile/presentation/view_model/my_bookings_view_model/my_bookings_event.dart';
import 'package:venure/features/profile/presentation/view_model/my_bookings_view_model/my_bookings_state.dart';
import 'package:venure/core/common/booking_card.dart';

import '../../view_model/my_bookings_view_model/my_booking_view_model_test.dart';

// Mock BookingBloc
class MockBookingBloc extends Mock implements BookingBloc {}

class FakeBookingEvent extends Fake implements BookingEvent {}

class FakeBookingState extends Fake implements BookingState {}

void main() {
  late MockBookingBloc mockBookingBloc;

  setUpAll(() {
    registerFallbackValue(FakeBookingEvent());
    registerFallbackValue(FakeBookingState());
  });

  setUp(() {
    mockBookingBloc = MockBookingBloc();
  });

  Widget createWidgetUnderTest() {
    // Wrap BlocProvider ABOVE MaterialApp so dialogs can find it
    return BlocProvider<BookingBloc>.value(
      value: mockBookingBloc,
      child: MaterialApp(home: const MyBookingsView()),
    );
  }

  testWidgets('shows loading indicator when loading', (tester) async {
    when(() => mockBookingBloc.state).thenReturn(BookingLoading());
    when(
      () => mockBookingBloc.stream,
    ).thenAnswer((_) => Stream.value(BookingLoading()));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error message when error state', (tester) async {
    const errorMessage = 'Failed to load bookings';

    when(
      () => mockBookingBloc.state,
    ).thenReturn(const BookingError(errorMessage));
    when(
      () => mockBookingBloc.stream,
    ).thenAnswer((_) => Stream.value(const BookingError(errorMessage)));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text('Something went wrong'), findsOneWidget);
    expect(find.text(errorMessage), findsOneWidget);
    expect(find.byIcon(Icons.error_outline), findsOneWidget);
  });

  testWidgets('shows empty state when no bookings', (tester) async {
    when(() => mockBookingBloc.state).thenReturn(const BookingLoaded([]));
    when(
      () => mockBookingBloc.stream,
    ).thenAnswer((_) => Stream.value(const BookingLoaded([])));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text('No bookings found'), findsOneWidget);
    expect(find.text('Your bookings will appear here'), findsOneWidget);
    expect(find.byIcon(Icons.event_busy), findsOneWidget);
  });

  testWidgets('shows list of bookings when loaded', (tester) async {
    final bookings = [
      MyBooking(
        id: 'booking1',
        status: 'booked',
        venue: Venue(
          id: 'venue1',
          ownerId: 'owner1',
          venueName: 'Venue 1',
          location: tVenueLocation,
          capacity: 100,
          venueImages: const [],
          description: null,
          amenities: const [],
          pricePerHour: 100,
          status: 'active',
          isDeleted: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        bookingDate: DateTime.now(),
        timeSlot: '10:00 AM - 12:00 PM',
        totalPrice: 1500,
      ),
      MyBooking(
        id: 'booking2',
        status: 'cancelled',
        venue: Venue(
          id: 'venue2',
          ownerId: 'owner2',
          venueName: 'Venue 2',
          location: tVenueLocation,
          capacity: 80,
          venueImages: const [],
          description: null,
          amenities: const [],
          pricePerHour: 80,
          status: 'active',
          isDeleted: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        bookingDate: DateTime.now(),
        timeSlot: '2:00 PM - 4:00 PM',
        totalPrice: 1200,
      ),
    ];

    when(() => mockBookingBloc.state).thenReturn(BookingLoaded(bookings));
    when(
      () => mockBookingBloc.stream,
    ).thenAnswer((_) => Stream.value(BookingLoaded(bookings)));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.byType(BookingCard), findsNWidgets(2));
    expect(find.text('Venue 1'), findsOneWidget);
    expect(find.text('Venue 2'), findsOneWidget);
  });

  testWidgets('cancel dialog shows and triggers CancelBooking event', (
    tester,
  ) async {
    final bookings = [
      MyBooking(
        id: 'booking1',
        status: 'booked', // onCancel enabled
        venue: Venue(
          id: 'venue1',
          ownerId: 'owner1',
          venueName: 'Venue 1',
          location: tVenueLocation,
          capacity: 100,
          venueImages: const [],
          description: null,
          amenities: const [],
          pricePerHour: 100,
          status: 'active',
          isDeleted: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        bookingDate: DateTime.now(),
        timeSlot: '10:00 AM - 12:00 PM',
        totalPrice: 1500,
      ),
    ];

    when(() => mockBookingBloc.state).thenReturn(BookingLoaded(bookings));
    when(
      () => mockBookingBloc.stream,
    ).thenAnswer((_) => Stream.value(BookingLoaded(bookings)));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // Tap cancel button
    await tester.tap(find.text('Cancel Booking'));
    await tester.pumpAndSettle();

    // Confirm dialog
    expect(find.text('Confirm Cancel'), findsOneWidget);
    expect(
      find.text('Are you sure you want to cancel this booking?'),
      findsOneWidget,
    );

    // Tap Yes
    await tester.tap(find.widgetWithText(TextButton, 'Yes'));
    await tester.pumpAndSettle();

    // Verify using matcher to avoid object identity issue
    verify(
      () => mockBookingBloc.add(
        any(
          that: isA<CancelBooking>().having(
            (e) => e.bookingId,
            'bookingId',
            'booking1',
          ),
        ),
      ),
    ).called(1);
  });
  testWidgets('cancel dialog closes when No is pressed without firing event', (
    tester,
  ) async {
    final bookings = [
      MyBooking(
        id: 'booking1',
        status: 'booked',
        venue: Venue(
          id: 'venue1',
          ownerId: 'owner1',
          venueName: 'Venue 1',
          location: tVenueLocation,
          capacity: 100,
          venueImages: const [],
          description: null,
          amenities: const [],
          pricePerHour: 100,
          status: 'active',
          isDeleted: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        bookingDate: DateTime.now(),
        timeSlot: '10:00 AM - 12:00 PM',
        totalPrice: 1500,
      ),
    ];

    when(() => mockBookingBloc.state).thenReturn(BookingLoaded(bookings));
    when(
      () => mockBookingBloc.stream,
    ).thenAnswer((_) => Stream.value(BookingLoaded(bookings)));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // Tap cancel button
    await tester.tap(find.text('Cancel Booking'));
    await tester.pumpAndSettle();

    // Confirm dialog appears
    expect(find.text('Confirm Cancel'), findsOneWidget);

    // Tap No button
    await tester.tap(find.widgetWithText(TextButton, 'No'));
    await tester.pumpAndSettle();

    // Dialog should close, so confirmation text gone
    expect(find.text('Confirm Cancel'), findsNothing);

    // Verify CancelBooking event NOT called
    verifyNever(() => mockBookingBloc.add(any()));
  });
}
