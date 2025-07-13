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
  }

  Future<void> _onLoadVenues(
    LoadVenues event,
    Emitter<HomeScreenState> emit,
  ) async {
    emit(HomeScreenLoading());
    final venuesResult = await getAllVenuesUseCase();
    final favoritesResult = await getFavoritesUseCase();

    venuesResult.fold((failure) => emit(HomeScreenError(failure.toString())), (
      venues,
    ) {
      favoritesResult.fold(
        (failure) => emit(HomeScreenError(failure.toString())),
        (favoriteIds) =>
            emit(HomeScreenLoaded(venues, favoriteVenueIds: favoriteIds)),
      );
    });
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
        emit(HomeScreenLoaded(currentVenues, favoriteVenueIds: favoriteIds));
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
    emit(
      HomeScreenLoaded(currentState.venues, favoriteVenueIds: updatedFavorites),
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
        emit(
          HomeScreenLoaded(
            currentState.venues,
            favoriteVenueIds: revertedFavorites,
          ),
        );
        // Optionally show error snackbar
      },
      (isNowFavorite) {
        // Success - nothing more to do as UI already updated
      },
    );
  }
}
