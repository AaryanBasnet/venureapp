abstract class SearchEvent {}
class SearchQueryChangedEvent extends SearchEvent {
  final String? query;
  final String? city;
  final String? capacityRange;
  final List<String>? amenities;
  final String? sort;

  SearchQueryChangedEvent({
    this.query,
    this.city,
    this.capacityRange,
    this.amenities,
    this.sort,
  });
}

class ToggleSearchFavoriteEvent extends SearchEvent {
  final String venueId;
  ToggleSearchFavoriteEvent(this.venueId);
}

class LoadDefaultVenuesEvent extends SearchEvent {}
