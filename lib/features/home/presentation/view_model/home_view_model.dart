import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/features/home/domain/use_case/get_%20favorites_usecase.dart';
import 'package:venure/features/home/domain/use_case/get_all_venues_use_case.dart';
import 'package:venure/features/home/domain/use_case/toggle_favorite_usecase.dart';

import 'package:venure/features/home/presentation/view_model/home_screen_event.dart';
import 'package:venure/features/home/presentation/view_model/home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  final GetAllVenuesUseCase getAllVenuesUseCase;
  final GetFavoritesUseCase getFavoritesUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;

  HomeScreenBloc({
    required this.getAllVenuesUseCase,
    required this.getFavoritesUseCase,
    required this.toggleFavoriteUseCase,
  }) : super(HomeScreenInitial()) {
    on<LoadVenues>(_onLoadVenues);
    on<LoadFavorites>(_onLoadFavorites);
    on<ToggleFavoriteVenue>(_onToggleFavorite);
    on<LoadMoreVenues>(_onLoadMoreVenues);
  }

  Future<void> _onLoadVenues(
    LoadVenues event,
    Emitter<HomeScreenState> emit,
  ) async {
    emit(HomeScreenLoading());

    final venuesResult = await getAllVenuesUseCase(page: 1);
    final favoritesResult = await getFavoritesUseCase();

    venuesResult.fold(
      (failure) {
        emit(HomeScreenError("Failed to load venues"));
      },
      (venues) {
        favoritesResult.fold(
          (failure) {
            emit(
              HomeScreenLoaded(
                venues,
                favoriteVenueIds: [],
                favoriteVenues: [],
                currentPage: 1,
                hasMore: venues.length >= 5,
              ),
            );
          },
          (favoriteIds) {
            final favoriteVenues =
                venues
                    .where((venue) => favoriteIds.contains(venue.id))
                    .toList();

            emit(
              HomeScreenLoaded(
                venues,
                favoriteVenueIds: favoriteIds,
                favoriteVenues: favoriteVenues,
                currentPage: 1,
                hasMore: venues.length >= 5,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onLoadMoreVenues(
    LoadMoreVenues event,
    Emitter<HomeScreenState> emit,
  ) async {
    if (state is! HomeScreenLoaded) return;
    final currentState = state as HomeScreenLoaded;

    final nextPage = currentState.currentPage + 1;
    const int limit =
        6; // Make sure this matches your backend's default or desired limit

    print('Loading more venues: page $nextPage, limit $limit');

    final venuesResult = await getAllVenuesUseCase(
      page: nextPage,
      limit: limit,
    );

    venuesResult.fold(
      (failure) {
        print('Failed to load more venues: ${failure.toString()}');
        // Optionally emit an error or show a snackbar
      },
      (newVenues) {
        print('Loaded ${newVenues.length} venues on page $nextPage');

        final updatedVenues = [...currentState.venues, ...newVenues];

        final updatedFavoriteVenues =
            updatedVenues
                .where(
                  (venue) => currentState.favoriteVenueIds.contains(venue.id),
                )
                .toList();

        emit(
          HomeScreenLoaded(
            updatedVenues,
            favoriteVenueIds: currentState.favoriteVenueIds,
            favoriteVenues: updatedFavoriteVenues,
            currentPage: nextPage,
            hasMore: newVenues.length >= limit,
          ),
        );
      },
    );
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<HomeScreenState> emit,
  ) async {
    final result = await getFavoritesUseCase();
    result.fold((failure) => emit(HomeScreenError(failure.toString())), (
      favoriteIds,
    ) {
      if (state is HomeScreenLoaded) {
        final currentVenues = (state as HomeScreenLoaded).venues;
        final favoriteVenues =
            currentVenues
                .where((venue) => favoriteIds.contains(venue.id))
                .toList();

        emit(
          HomeScreenLoaded(
            currentVenues,
            favoriteVenueIds: favoriteIds,
            favoriteVenues: favoriteVenues,
            currentPage: (state as HomeScreenLoaded).currentPage,
            hasMore: (state as HomeScreenLoaded).hasMore,
          ),
        );
      }
    });
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteVenue event,
    Emitter<HomeScreenState> emit,
  ) async {
    if (state is! HomeScreenLoaded) return;

    final currentState = state as HomeScreenLoaded;

    final updatedFavorites = List<String>.from(currentState.favoriteVenueIds);
    final wasFavorite = updatedFavorites.contains(event.venueId);

    if (wasFavorite) {
      updatedFavorites.remove(event.venueId);
    } else {
      updatedFavorites.add(event.venueId);
    }

    // Immediately emit updated state for instant UI update
    final updatedFavoriteVenues =
        currentState.venues
            .where((venue) => updatedFavorites.contains(venue.id))
            .toList();

    emit(
      HomeScreenLoaded(
        currentState.venues,
        favoriteVenueIds: updatedFavorites,
        favoriteVenues: updatedFavoriteVenues,
        currentPage: currentState.currentPage,
        hasMore: currentState.hasMore,
      ),
    );

    // Persist change asynchronously
    final toggleResult = await toggleFavoriteUseCase(event.venueId);

    toggleResult.fold(
      (failure) {
        // On failure, revert the favorite toggle in UI
        final revertedFavorites = List<String>.from(updatedFavorites);
        if (wasFavorite) {
          revertedFavorites.add(event.venueId);
        } else {
          revertedFavorites.remove(event.venueId);
        }

        final revertedFavoriteVenues =
            currentState.venues
                .where((venue) => revertedFavorites.contains(venue.id))
                .toList();

        emit(
          HomeScreenLoaded(
            currentState.venues,
            favoriteVenueIds: revertedFavorites,
            favoriteVenues: revertedFavoriteVenues,
            currentPage: currentState.currentPage,
            hasMore: currentState.hasMore,
          ),
        );

        // Optionally show error snackbar
      },
      (isNowFavorite) {
        // Success - UI already updated, no action needed
      },
    );
  }
}
