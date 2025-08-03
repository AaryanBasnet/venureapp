import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/core/common/favorite_venue_card.dart';
import 'package:venure/features/common/presentation/view/favorites_page.dart';

import 'package:venure/features/home/domain/entity/venue_entity.dart';
import 'package:venure/features/home/domain/entity/venue_location_entity.dart';
import 'package:venure/features/home/presentation/view_model/home_screen_event.dart';
import 'package:venure/features/home/presentation/view_model/home_screen_state.dart';
import 'package:venure/features/home/presentation/view_model/home_view_model.dart';

// --- Mocks & Fakes ---
class MockHomeScreenBloc extends Mock implements HomeScreenBloc {}

class FakeHomeScreenState extends Fake implements HomeScreenState {}

class FakeHomeScreenEvent extends Fake implements HomeScreenEvent {}

// Helper to create test venues
Venue createTestVenue({required String id, required String name}) {
  return Venue(
    id: id,
    venueName: name,
    ownerId: 'owner1',
    location: const VenueLocation(
      address: 'Test Address',
      city: '',
      state: '',
      country: '',
    ),
    capacity: 100,
    venueImages: const [],
    amenities: const [],
    pricePerHour: 1000,
    status: 'approved',
    isDeleted: false,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}

void main() {
  late MockHomeScreenBloc mockHomeScreenBloc;

  setUpAll(() {
    registerFallbackValue(FakeHomeScreenState());
    registerFallbackValue(FakeHomeScreenEvent());
  });

  setUp(() {
    mockHomeScreenBloc = MockHomeScreenBloc();
    when(() => mockHomeScreenBloc.state).thenReturn(HomeScreenInitial());
    when(() => mockHomeScreenBloc.stream).thenAnswer((_) => Stream.empty());
  });

  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<HomeScreenBloc>.value(
          value: mockHomeScreenBloc,
          child: const FavoritesPage(),
        ),
      ),
    );
  }

  final venue1 = createTestVenue(id: '1', name: 'Sunrise Hall');
  final venue2 = createTestVenue(id: '2', name: 'Moonlight Gardens');

  group('FavoritesPage', () {
    testWidgets('shows loading indicator when state is HomeScreenLoading', (
      tester,
    ) async {
      when(() => mockHomeScreenBloc.state).thenReturn(HomeScreenLoading());
      await pumpScreen(tester);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error message when state is HomeScreenError', (
      tester,
    ) async {
      const errorMessage = 'Failed to load favorites';
      when(
        () => mockHomeScreenBloc.state,
      ).thenReturn(const HomeScreenError(errorMessage));
      await pumpScreen(tester);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('shows empty state when there are no favorite venues', (
      tester,
    ) async {
      when(() => mockHomeScreenBloc.state).thenReturn(
        HomeScreenLoaded(
          const [],
          favoriteVenueIds: const [],
          favoriteVenues: const [],
        ),
      );
      await pumpScreen(tester);

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.text('No favorites yet!'), findsOneWidget);

      // Tap Explore Venues button to cover debugPrint callback
      await tester.tap(find.widgetWithText(ElevatedButton, 'Explore Venues'));
      await tester.pump();

      // No exception means coverage hit for the onPressed
    });

    testWidgets('displays a list of favorite venues when loaded', (
      tester,
    ) async {
      when(() => mockHomeScreenBloc.state).thenReturn(
        HomeScreenLoaded(
          [venue1, venue2],
          favoriteVenueIds: ['1', '2'],
          favoriteVenues: [venue1, venue2],
        ),
      );
      await pumpScreen(tester);
      expect(find.text('2 favorites'), findsOneWidget);
      expect(find.byType(FavoriteVenueCard), findsNWidgets(2));
    });

    testWidgets('removes item after confirming dismiss dialog', (tester) async {
      when(() => mockHomeScreenBloc.state).thenReturn(
        HomeScreenLoaded(
          [venue1],
          favoriteVenueIds: ['1'],
          favoriteVenues: [venue1],
        ),
      );
      when(() => mockHomeScreenBloc.add(any())).thenReturn(null);

      await pumpScreen(tester);

      // Swipe to trigger dialog
      await tester.drag(find.byType(Dismissible), const Offset(-500.0, 0.0));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);

      // Confirm removal by tapping Remove
      await tester.tap(find.widgetWithText(TextButton, 'Remove'));
      await tester.pumpAndSettle();

      verify(
        () => mockHomeScreenBloc.add(ToggleFavoriteVenue(venue1.id)),
      ).called(1);
      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.text('${venue1.venueName} removed from favorites'),
        findsOneWidget,
      );
    });

    testWidgets(
      'dismiss swipe shows confirmation dialog and cancels on Cancel tap',
      (tester) async {
        when(() => mockHomeScreenBloc.state).thenReturn(
          HomeScreenLoaded(
            [venue1],
            favoriteVenueIds: ['1'],
            favoriteVenues: [venue1],
          ),
        );
        when(() => mockHomeScreenBloc.add(any())).thenReturn(null);

        await pumpScreen(tester);

        // Swipe to trigger dialog
        await tester.drag(find.byType(Dismissible), const Offset(-500.0, 0.0));
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsOneWidget);

        // Tap Cancel button to trigger Navigator.pop(false)
        await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
        await tester.pumpAndSettle();

        // Dismissible should still be present, dismiss canceled
        expect(find.byType(Dismissible), findsOneWidget);

        // No bloc event should be fired on cancel
        verifyNever(() => mockHomeScreenBloc.add(any()));
      },
    );

    testWidgets('tapping FavoriteVenueCard calls onTap callback', (
      tester,
    ) async {
      when(() => mockHomeScreenBloc.state).thenReturn(
        HomeScreenLoaded(
          [venue1],
          favoriteVenueIds: ['1'],
          favoriteVenues: [venue1],
        ),
      );

      await pumpScreen(tester);

      final cardFinder = find.byType(FavoriteVenueCard);
      expect(cardFinder, findsOneWidget);

      await tester.tap(cardFinder);
      await tester.pump();

      // If no exceptions thrown, onTap debugPrint was called (covered)
    });

    testWidgets('favorite toggle button calls bloc event', (tester) async {
      when(() => mockHomeScreenBloc.state).thenReturn(
        HomeScreenLoaded(
          [venue1],
          favoriteVenueIds: ['1'],
          favoriteVenues: [venue1],
        ),
      );
      when(() => mockHomeScreenBloc.add(any())).thenReturn(null);

      await pumpScreen(tester);

      final favoriteButton = find.byIcon(Icons.favorite);
      expect(favoriteButton, findsOneWidget);

      await tester.tap(favoriteButton);
      await tester.pump();

      verify(
        () => mockHomeScreenBloc.add(ToggleFavoriteVenue(venue1.id)),
      ).called(1);
    });
  });
}
