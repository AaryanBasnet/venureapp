import 'package:equatable/equatable.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object> get props => [];
}

class LoadFavorites extends FavoritesEvent {}

class UnfavoriteVenue extends FavoritesEvent {
  final String venueId;

  const UnfavoriteVenue(this.venueId);

  @override
  List<Object> get props => [venueId];
}
