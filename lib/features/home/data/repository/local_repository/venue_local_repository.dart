import 'package:dartz/dartz.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/home/data/data_source/local_data_source/venue_local_datasource.dart';
import 'package:venure/features/home/domain/entity/venue_entity.dart';
import 'package:venure/features/home/domain/repository/venue_repository.dart';

class VenueLocalRepository implements IVenueRepository {
  final VenueLocalDataSource localDataSource;

  VenueLocalRepository({required this.localDataSource});

  @override
  Future<Either<Failure, List<Venue>>> getAllVenues() async {
    try {
      final venues = await localDataSource.getAllVenues();
      return Right(venues);
    } catch (e) {
      return Left(LocalDataBaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Venue>> getVenueById(String id) async {
    try {
      final venue = await localDataSource.getVenueById(id);
      return Right(venue);
    } catch (e) {
      return Left(LocalDataBaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Venue>> addVenue(Venue venue) async {
    try {
      final addedVenue = await localDataSource.addVenue(venue);
      return Right(addedVenue);
    } catch (e) {
      return Left(LocalDataBaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Venue>> updateVenue(Venue venue) async {
    try {
      final updatedVenue = await localDataSource.updateVenue(venue);
      return Right(updatedVenue);
    } catch (e) {
      return Left(LocalDataBaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteVenue(String id) async {
    try {
      await localDataSource.deleteVenue(id);
      return const Right(null);
    } catch (e) {
      return Left(LocalDataBaseFailure(message: e.toString()));
    }
  }

  // Favorites

  @override
  Future<Either<Failure, List<String>>> getFavorites() async {
    try {
      final favorites = await localDataSource.getFavoriteVenueIds();
      return Right(favorites);
    } catch (e) {
      return Left(LocalDataBaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFavorite(String venueId) async {
    try {
      final toggled = await localDataSource.toggleFavoriteVenue(venueId);
      return Right(toggled);
    } catch (e) {
      return Left(LocalDataBaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Venue>>> getFavoriteVenues() async {
    try {
      final venues = await localDataSource.getFavoriteVenues();
      return Right(venues);
    } catch (e) {
      return Left(LocalDataBaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Venue>>> searchVenues({
    String? search,
    String? city,
    String? capacityRange,
    List<String>? amenities,
    String? sort,
    int page = 1,
    int limit = 6,
  }) async {
    try {
      final venues = await localDataSource.searchVenues(
        search: search,
        city: city,
        capacityRange: capacityRange,
        amenities: amenities,
        sort: sort,
        page: page,
        limit: limit,
      );
      return Right(venues);
    } catch (e) {
      return Left(LocalDataBaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Venue>>> getVenuesByIds(List<String> ids) async {
    try {
      final allVenues = await localDataSource.getAllVenues();
      final filtered = allVenues.where((v) => ids.contains(v.id)).toList();
      return Right(filtered);
    } catch (e) {
      return Left(LocalDataBaseFailure(message: e.toString()));
    }
  }
   @override
Future<Either<Failure, List<Venue>>> getCachedVenues() async {
  try {
    final cachedVenues = await localDataSource.getAllVenues(); // or a specific cache method
    return Right(cachedVenues);
  } catch (e) {
    return Left(LocalDataBaseFailure(message: e.toString()));
  }
}

@override
Future<void> cacheVenues(List<Venue> venues) async {
  try {
    await localDataSource.saveAllVenues(venues);
  } catch (e) {
    throw LocalDataBaseFailure(message: e.toString());
  }
}

Future<void> saveAllVenues(List<Venue> venues) async {
  await localDataSource.saveAllVenues(venues);
}


Future<void> cacheFavoriteVenueIds(List<String> ids) async {
  await localDataSource.saveFavoriteVenueIds(ids);
  print("🟢 VenueLocalRepository: Cached favorite venue IDs: $ids");
}

Future<Either<Failure, List<String>>> getCachedFavoriteVenueIds() async {
  try {
    final cached = await localDataSource.getFavoriteVenueIds();
    print("🟢 VenueLocalRepository: Retrieved cached favorite venue IDs: $cached");
    return Right(cached);
  } catch (e) {
    print("🔴 VenueLocalRepository: Error getting cached favorite venue IDs: $e");
    return Left(LocalDataBaseFailure(message: e.toString()));
  }
}

}








