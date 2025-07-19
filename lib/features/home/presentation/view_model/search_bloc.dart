import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/features/home/domain/use_case/get_%20favorites_usecase.dart';
import 'package:venure/features/home/domain/use_case/search_venue_usecase.dart';
import 'package:venure/features/home/domain/use_case/toggle_favorite_usecase.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchVenuesUseCase searchVenuesUseCase;
  final GetFavoritesUseCase getFavoritesUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;

  SearchBloc({
    required this.searchVenuesUseCase,
    required this.getFavoritesUseCase,
    required this.toggleFavoriteUseCase,
  }) : super(SearchInitial()) {
    on<LoadDefaultVenuesEvent>(_onLoadDefaultVenues);
    on<SearchQueryChangedEvent>(_onSearchQueryChanged);
    on<ToggleSearchFavoriteEvent>(_onToggleFavorite);
  }

  Future<void> _onLoadDefaultVenues(
      LoadDefaultVenuesEvent event, Emitter<SearchState> emit) async {
    emit(SearchLoading());

    final result = await searchVenuesUseCase(
      searchQuery: null,
      city: null,
      capacityRange: null,
      amenities: null,
      sort: null,
      page: 1,
      limit: 10, // Limit to prevent server overload
    );

    final favoritesResult = await getFavoritesUseCase();

    result.fold(
      (failure) => emit(SearchError(failure.toString())),
      (venues) {
        favoritesResult.fold(
          (failure) => emit(SearchError(failure.toString())),
          (favoriteIds) => emit(SearchLoaded(venues, favoriteVenueIds: favoriteIds)),
        );
      },
    );
  }

  Future<void> _onSearchQueryChanged(
      SearchQueryChangedEvent event, Emitter<SearchState> emit) async {
    emit(SearchLoading());

    final result = await searchVenuesUseCase(
      searchQuery: event.query,
      city: event.city,
      capacityRange: event.capacityRange,
      amenities: event.amenities,
      sort: event.sort,
      page: 1,
      limit: 10,
    );

    final favoritesResult = await getFavoritesUseCase();

    result.fold(
      (failure) => emit(SearchError(failure.toString())),
      (venues) {
        favoritesResult.fold(
          (failure) => emit(SearchError(failure.toString())),
          (favoriteIds) => emit(SearchLoaded(venues, favoriteVenueIds: favoriteIds)),
        );
      },
    );
  }

  Future<void> _onToggleFavorite(
      ToggleSearchFavoriteEvent event, Emitter<SearchState> emit) async {
    if (state is! SearchLoaded) return;
    final currentState = state as SearchLoaded;

    final updatedFavorites = List<String>.from(currentState.favoriteVenueIds);
    final wasFavorite = updatedFavorites.contains(event.venueId);

    if (wasFavorite) {
      updatedFavorites.remove(event.venueId);
    } else {
      updatedFavorites.add(event.venueId);
    }

    emit(SearchLoaded(currentState.venues, favoriteVenueIds: updatedFavorites));

    final toggleResult = await toggleFavoriteUseCase(event.venueId);

    toggleResult.fold(
      (failure) {
        final revertedFavorites = List<String>.from(updatedFavorites);
        if (wasFavorite) {
          revertedFavorites.add(event.venueId);
        } else {
          revertedFavorites.remove(event.venueId);
        }
        emit(SearchLoaded(currentState.venues, favoriteVenueIds: revertedFavorites));
      },
      (isNowFavorite) {
        // Success: keep optimistic update
      },
    );
  }
}
