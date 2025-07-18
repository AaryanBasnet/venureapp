import 'package:equatable/equatable.dart';
import 'package:venure/features/home/domain/entity/venue_entity.dart';

abstract class VenueDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VenueDetailsInitial extends VenueDetailsState {}

class VenueDetailsLoading extends VenueDetailsState {}

class VenueDetailsLoaded extends VenueDetailsState {
  final Venue venue;

  VenueDetailsLoaded(this.venue);

  @override
  List<Object?> get props => [venue];
}

class VenueDetailsError extends VenueDetailsState {
  final String message;

  VenueDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
