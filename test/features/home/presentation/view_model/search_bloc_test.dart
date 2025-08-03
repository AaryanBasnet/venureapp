import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/home/domain/entity/venue_entity.dart';
import 'package:venure/features/home/domain/entity/venue_location_entity.dart';
import 'package:venure/features/home/domain/use_case/get_%20favorites_usecase.dart';
import 'package:venure/features/home/domain/use_case/search_venue_usecase.dart';
import 'package:venure/features/home/domain/use_case/toggle_favorite_usecase.dart';
import 'package:venure/features/home/presentation/view_model/search_bloc.dart';
import 'package:venure/features/home/presentation/view_model/search_event.dart';
import 'package:venure/features/home/presentation/view_model/search_state.dart';

// Mocks for UseCases
class MockSearchVenuesUseCase extends Mock implements SearchVenuesUseCase {}

class MockGetFavoritesUseCase extends Mock implements GetFavoritesUseCase {}

class MockToggleFavoriteUseCase extends Mock implements ToggleFavoriteUseCase {}

// A concrete Venue class that can be instantiated for tests
class TestVenue extends Venue {
  TestVenue({required super.id, required super.venueName})
    : super(
        ownerId: 'owner-$id',
        location: VenueLocation(address: '', city: '', state: '', country: ''),
        capacity: 100,
        venueImages: [],
        amenities: [],
        pricePerHour: 100.0,
        status: 'active',
        isDeleted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
}

void main() {
  late SearchBloc searchBloc;
  late MockSearchVenuesUseCase mockSearchVenuesUseCase;
  late MockGetFavoritesUseCase mockGetFavoritesUseCase;
  late MockToggleFavoriteUseCase mockToggleFavoriteUseCase;

  // Test Data
  final tVenue1 = TestVenue(id: 'venue-1', venueName: 'Royal Palace');
  final tVenue2 = TestVenue(id: 'venue-2', venueName: 'Grand Hall');
  final tAllVenues = [tVenue1, tVenue2];
  final tFavoriteIds = ['venue-1'];
  const tApiFailure = ApiFailure(message: 'API Error');

  setUp(() {
    mockSearchVenuesUseCase = MockSearchVenuesUseCase();
    mockGetFavoritesUseCase = MockGetFavoritesUseCase();
    mockToggleFavoriteUseCase = MockToggleFavoriteUseCase();
    searchBloc = SearchBloc(
      searchVenuesUseCase: mockSearchVenuesUseCase,
      getFavoritesUseCase: mockGetFavoritesUseCase,
      toggleFavoriteUseCase: mockToggleFavoriteUseCase,
    );
  });

  tearDown(() {
    searchBloc.close();
  });

  test('initial state is SearchInitial', () {
    expect(searchBloc.state, equals(SearchInitial()));
  });

  group('LoadDefaultVenuesEvent', () {
    // This is the setup for the mock call that will be used in this group
    void setupMockSearchVenuesSuccess() {
      when(
        () => mockSearchVenuesUseCase(
          searchQuery: any(named: 'searchQuery'),
          city: any(named: 'city'),
          capacityRange: any(named: 'capacityRange'),
          amenities: any(named: 'amenities'),
          sort: any(named: 'sort'),
          page: any(named: 'page'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => Right(tAllVenues));
    }

    blocTest<SearchBloc, SearchState>(
      'emits [SearchLoading, SearchLoaded] on full success',
      build: () {
        setupMockSearchVenuesSuccess();
        when(
          () => mockGetFavoritesUseCase(),
        ).thenAnswer((_) async => Right(tFavoriteIds));
        return searchBloc;
      },
      act: (bloc) => bloc.add(LoadDefaultVenuesEvent()),
      expect:
          () => [
            SearchLoading(),
            SearchLoaded(tAllVenues, favoriteVenueIds: tFavoriteIds),
          ],
    );

    blocTest<SearchBloc, SearchState>(
      'emits [SearchLoading, SearchError] if searchVenuesUseCase fails',
      build: () {
        when(
          () => mockSearchVenuesUseCase(
            searchQuery: any(named: 'searchQuery'),
            city: any(named: 'city'),
            capacityRange: any(named: 'capacityRange'),
            amenities: any(named: 'amenities'),
            sort: any(named: 'sort'),
            page: any(named: 'page'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => const Left(tApiFailure));
        // Note: getFavoritesUseCase is still called in the BLoC, so we mock it.
        when(
          () => mockGetFavoritesUseCase(),
        ).thenAnswer((_) async => Right(tFavoriteIds));
        return searchBloc;
      },
      act: (bloc) => bloc.add(LoadDefaultVenuesEvent()),
      expect: () => [SearchLoading(), SearchError(tApiFailure.toString())],
    );

    // --- THIS TEST COVERS THE MISSING LINE ---
    blocTest<SearchBloc, SearchState>(
      'emits [SearchLoading, SearchError] if getFavoritesUseCase fails',
      build: () {
        setupMockSearchVenuesSuccess();
        when(
          () => mockGetFavoritesUseCase(),
        ).thenAnswer((_) async => const Left(tApiFailure));
        return searchBloc;
      },
      act: (bloc) => bloc.add(LoadDefaultVenuesEvent()),
      expect: () => [SearchLoading(), SearchError(tApiFailure.toString())],
    );
  });

  group('SearchQueryChangedEvent', () {
    const tQuery = 'Royal';
    final tFilteredVenues = [tVenue1];

    // Setup for a successful search query mock
    void setupMockSearchQuerySuccess() {
      when(
        () => mockSearchVenuesUseCase(
          searchQuery: tQuery,
          city: any(named: 'city'),
          capacityRange: any(named: 'capacityRange'),
          amenities: any(named: 'amenities'),
          sort: any(named: 'sort'),
          page: any(named: 'page'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => Right(tFilteredVenues));
    }

    blocTest<SearchBloc, SearchState>(
      'emits [SearchLoading, SearchLoaded] with filtered results on success',
      build: () {
        setupMockSearchQuerySuccess();
        when(
          () => mockGetFavoritesUseCase(),
        ).thenAnswer((_) async => Right(tFavoriteIds));
        return searchBloc;
      },
      act: (bloc) => bloc.add(SearchQueryChangedEvent(query: tQuery)),
      expect:
          () => [
            SearchLoading(),
            SearchLoaded(tFilteredVenues, favoriteVenueIds: tFavoriteIds),
          ],
    );

    blocTest<SearchBloc, SearchState>(
      'emits [SearchLoading, SearchError] when searchVenuesUseCase fails in SearchQueryChangedEvent',
      build: () {
        when(
          () => mockSearchVenuesUseCase(
            searchQuery: any(named: 'searchQuery'),
            city: any(named: 'city'),
            capacityRange: any(named: 'capacityRange'),
            amenities: any(named: 'amenities'),
            sort: any(named: 'sort'),
            page: any(named: 'page'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => const Left(tApiFailure)); // Fail immediately

        // Even though it won't be called in this case, still mock it
        when(
          () => mockGetFavoritesUseCase(),
        ).thenAnswer((_) async => const Right(<String>[]));

        return searchBloc;
      },
      act: (bloc) => bloc.add(SearchQueryChangedEvent(query: 'fail-query')),
      expect:
          () => [
            SearchLoading(),
            SearchError(
              tApiFailure.toString(),
            ), // <— This covers the missing failure lambda
          ],
    );

    // --- THIS TEST COVERS THE MISSING LINE FOR THIS EVENT ---
    blocTest<SearchBloc, SearchState>(
      'emits [SearchLoading, SearchError] if getFavoritesUseCase fails after search',
      build: () {
        setupMockSearchQuerySuccess();
        when(
          () => mockGetFavoritesUseCase(),
        ).thenAnswer((_) async => const Left(tApiFailure));
        return searchBloc;
      },
      act: (bloc) => bloc.add(SearchQueryChangedEvent(query: tQuery)),
      expect: () => [SearchLoading(), SearchError(tApiFailure.toString())],
    );
  });

  group('ToggleSearchFavoriteEvent', () {
    const tVenueToToggle = 'venue-2';
    const tVenueToRemove = 'venue-1';

    blocTest<SearchBloc, SearchState>(
      'optimistically adds a favorite and keeps it on success',
      build: () {
        when(
          () => mockToggleFavoriteUseCase(tVenueToToggle),
        ).thenAnswer((_) async => const Right(true));
        return searchBloc;
      },
      seed: () => SearchLoaded(tAllVenues, favoriteVenueIds: tFavoriteIds),
      act: (bloc) => bloc.add(ToggleSearchFavoriteEvent(tVenueToToggle)),
      expect:
          () => [
            SearchLoaded(
              tAllVenues,
              favoriteVenueIds: [...tFavoriteIds, tVenueToToggle],
            ),
          ],
    );

    blocTest<SearchBloc, SearchState>(
      'optimistically removes a favorite and keeps it on success',
      build: () {
        when(
          () => mockToggleFavoriteUseCase(tVenueToRemove),
        ).thenAnswer((_) async => const Right(false));
        return searchBloc;
      },
      seed: () => SearchLoaded(tAllVenues, favoriteVenueIds: tFavoriteIds),
      act: (bloc) => bloc.add(ToggleSearchFavoriteEvent(tVenueToRemove)),
      expect: () => [SearchLoaded(tAllVenues, favoriteVenueIds: [])],
    );

    blocTest<SearchBloc, SearchState>(
      'reverts adding a favorite if the use case fails',
      build: () {
        when(
          () => mockToggleFavoriteUseCase(tVenueToToggle),
        ).thenAnswer((_) async => const Left(tApiFailure));
        return searchBloc;
      },
      seed: () => SearchLoaded(tAllVenues, favoriteVenueIds: tFavoriteIds),
      act: (bloc) => bloc.add(ToggleSearchFavoriteEvent(tVenueToToggle)),
      expect:
          () => [
            SearchLoaded(
              tAllVenues,
              favoriteVenueIds: [...tFavoriteIds, tVenueToToggle],
            ), // Optimistic add
            SearchLoaded(tAllVenues, favoriteVenueIds: tFavoriteIds), // Revert
          ],
    );

    blocTest<SearchBloc, SearchState>(
      'reverts removing a favorite if the use case fails',
      build: () {
        when(
          () => mockToggleFavoriteUseCase(tVenueToRemove),
        ).thenAnswer((_) async => const Left(tApiFailure));
        return searchBloc;
      },
      seed: () => SearchLoaded(tAllVenues, favoriteVenueIds: tFavoriteIds),
      act: (bloc) => bloc.add(ToggleSearchFavoriteEvent(tVenueToRemove)),
      expect:
          () => [
            SearchLoaded(tAllVenues, favoriteVenueIds: []), // Optimistic remove
            SearchLoaded(tAllVenues, favoriteVenueIds: tFavoriteIds), // Revert
          ],
    );

    blocTest<SearchBloc, SearchState>(
      'does nothing if state is not SearchLoaded',
      build: () => searchBloc,
      seed: () => SearchInitial(),
      act: (bloc) => bloc.add(ToggleSearchFavoriteEvent(tVenueToToggle)),
      expect: () => [],
      verify: (_) => verifyNever(() => mockToggleFavoriteUseCase(any())),
    );
  });
}
