import 'package:equatable/equatable.dart';

abstract class VenueDetailsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadVenueDetails extends VenueDetailsEvent {
  final String venueId;

  LoadVenueDetails(this.venueId);

  @override
  List<Object> get props => [venueId];
}
