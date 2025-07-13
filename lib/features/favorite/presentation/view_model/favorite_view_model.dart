import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/features/home/domain/entity/venue_entity.dart';
import 'package:venure/features/home/domain/repository/venue_repository.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final IVenueRepository venueRepository;

  FavoritesBloc({required this.venueRepository}) : super(FavoritesInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<UnfavoriteVenue>(_onUnfavoriteVenue);
  }

  Future<void> _onLoadFavorites(
      LoadFavorites event,
      Emitter<FavoritesState> emit,
      ) async {
    emit(FavoritesLoading());

    final failureOrVenues = await venueRepository.getFavoriteVenues();

    failureOrVenues.fold(
          (failure) => emit(FavoritesError(failure.toString())),
          (venues) => emit(FavoritesLoaded(venues)),
    );
  }

  Future<void> _onUnfavoriteVenue(
      UnfavoriteVenue event,
      Emitter<FavoritesState> emit,
      ) async {
    if (state is! FavoritesLoaded) return;

    final currentState = state as FavoritesLoaded;
    final currentFavorites = List<Venue>.from(currentState.favoriteVenues);

    // Optimistic UI update: remove immediately
    currentFavorites.removeWhere((venue) => venue.id == event.venueId);
    emit(FavoritesLoaded(currentFavorites));

    // Call repository to toggle favorite off
    final failureOrSuccess = await venueRepository.toggleFavorite(event.venueId);

    failureOrSuccess.fold(
          (failure) {
        // Revert UI on failure
        emit(FavoritesError(failure.toString()));
        emit(currentState);
      },
          (success) {
        // success: do nothing, UI already updated
      },
    );
  }
}
