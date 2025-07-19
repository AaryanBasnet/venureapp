import 'package:dartz/dartz.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/home/domain/entity/venue_entity.dart';

abstract interface class IVenueRepository {
  Future<Either<Failure, List<Venue>>> getAllVenues();
  Future<Either<Failure, Venue>> getVenueById(String id);
  Future<Either<Failure, Venue>> addVenue(Venue venue);
  Future<Either<Failure, Venue>> updateVenue(Venue venue);
  Future<Either<Failure, void>> deleteVenue(String id);

  Future<Either<Failure, List<Venue>>> searchVenues({
  String? search,
  String? city,
  String? capacityRange,
  List<String>? amenities,
  String? sort,
  int page = 1,
  int limit = 6,
});


  // Favorites
  Future<Either<Failure, List<String>>>
  getFavorites(); // returns list of favorite venue IDs
  Future<Either<Failure, bool>> toggleFavorite(
    String venueId,
  ); // returns new favorite status (true if favorited)
  Future<Either<Failure, List<Venue>>> getFavoriteVenues(); // <-- Only this needed for Favorite Page}
}