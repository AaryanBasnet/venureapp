import 'package:equatable/equatable.dart';
import 'package:venure/features/home/domain/entity/venue_entity.dart';

abstract class HomeScreenState extends Equatable {
  const HomeScreenState();

  @override
  List<Object> get props => [];
}

class HomeScreenInitial extends HomeScreenState {}

class HomeScreenLoading extends HomeScreenState {}

class HomeScreenLoaded extends HomeScreenState {
  final List<Venue> venues;
  final List<String> favoriteVenueIds;

  const HomeScreenLoaded(this.venues, {this.favoriteVenueIds = const []});

  @override
  List<Object> get props => [venues, favoriteVenueIds];
}

class HomeScreenError extends HomeScreenState {
  final String error;

  const HomeScreenError(this.error);
}
