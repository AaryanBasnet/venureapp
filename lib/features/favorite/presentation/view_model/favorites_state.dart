import 'package:equatable/equatable.dart';
import 'package:venure/features/home/domain/entity/venue_entity.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<Venue> favoriteVenues;

  const FavoritesLoaded(this.favoriteVenues);

  @override
  List<Object> get props => [favoriteVenues];
}

class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError(this.message);

  @override
  List<Object> get props => [message];
}
