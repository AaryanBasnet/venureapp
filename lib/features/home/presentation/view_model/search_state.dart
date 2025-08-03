import 'package:equatable/equatable.dart';
import 'package:venure/features/home/domain/entity/venue_entity.dart';

 class SearchState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
 }

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Venue> venues;
  final List<String> favoriteVenueIds;

  SearchLoaded(this.venues, {this.favoriteVenueIds = const []});
  @override
  List<Object?> get props => [venues, favoriteVenueIds];
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
  @override
  List<Object?> get props => [message];
}
