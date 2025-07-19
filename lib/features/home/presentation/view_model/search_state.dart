import 'package:venure/features/home/domain/entity/venue_entity.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Venue> venues;
  final List<String> favoriteVenueIds;

  SearchLoaded(this.venues, {this.favoriteVenueIds = const []});
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}
