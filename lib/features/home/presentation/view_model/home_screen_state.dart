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
  final List<Venue> favoriteVenues;
  final int currentPage;
  final bool hasMore;

  const HomeScreenLoaded(
    this.venues, {
    required this.favoriteVenueIds,
    required this.favoriteVenues,
    this.currentPage = 1,
    this.hasMore = true,
  });

  @override
  List<Object> get props => [
        venues,
        favoriteVenueIds,
        favoriteVenues,
        currentPage,
        hasMore,
      ];
}


class HomeScreenError extends HomeScreenState {
  final String error;

  const HomeScreenError(this.error);
}
