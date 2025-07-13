import 'package:venure/features/home/domain/entity/venue_entity.dart';

abstract interface class IVenueDataSource {
  Future<List<Venue>> getAllVenues();
  Future<Venue> getVenueById(String id);
  Future<Venue> addVenue(Venue venue);
  Future<Venue> updateVenue(Venue venue);
  Future<void> deleteVenue(String id);

  // Favorites related methods
  Future<List<String>> getFavoriteVenueIds();
  Future<bool> toggleFavoriteVenue(String venueId);
  Future<List<Venue>> getFavoriteVenues();
}
