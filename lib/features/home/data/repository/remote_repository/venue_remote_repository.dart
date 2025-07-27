import 'package:dartz/dartz.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/home/data/data_source/remote_data_source/venue_remote_datasource.dart';
import 'package:venure/features/home/domain/entity/venue_entity.dart';
import 'package:venure/features/home/domain/repository/venue_repository.dart';

class VenueRemoteRepository implements IVenueRepository {
  final VenueRemoteDataSource remoteDataSource;

  VenueRemoteRepository({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Venue>>> getAllVenues(
    {int page = 1, int limit = 5}
  ) async {
    try {
      final venues = await remoteDataSource.getAllVenues(
        page: page,
        limit: limit,
      );
      return Right(venues);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Venue>> getVenueById(String id) async {
    try {
      final venue = await remoteDataSource.getVenueById(id);
      return Right(venue);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Venue>> addVenue(Venue venue) async {
    try {
      final addedVenue = await remoteDataSource.addVenue(venue);
      return Right(addedVenue);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Venue>> updateVenue(Venue venue) async {
    try {
      final updatedVenue = await remoteDataSource.updateVenue(venue);
      return Right(updatedVenue);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteVenue(String id) async {
    try {
      await remoteDataSource.deleteVenue(id);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  // Favorites

  @override
Future<Either<Failure, List<String>>> getFavorites() async {
  try {
    final ids = await remoteDataSource.getFavoriteVenueIds();
    return Right(ids);
  } catch (e) {
    return Left(ApiFailure(message: e.toString()));
  }
}

@override
Future<Either<Failure, bool>> toggleFavorite(String venueId) async {
  try {
    final result = await remoteDataSource.toggleFavoriteVenue(venueId);
    return Right(result);
  } catch (e) {
    return Left(ApiFailure(message: e.toString()));
  }
}

@override
Future<Either<Failure, List<Venue>>> getFavoriteVenues() async {
  try {
    final venues = await remoteDataSource.getFavoriteVenues();
    return Right(venues);
  } catch (e) {
    return Left(ApiFailure(message: e.toString()));
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
    final venues = await remoteDataSource.searchVenues(
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
    return Left(ApiFailure(message: e.toString()));
  }
}

@override
Future<Either<Failure, List<Venue>>> getVenuesByIds(List<String> ids) async {
  try {
    final venues = <Venue>[];
    for (final id in ids) {
      final result = await getVenueById(id);
      result.fold(
        (failure) => throw Exception('Failed to fetch venue $id: ${failure.message}'),
        (venue) => venues.add(venue),
      );
    }
    return Right(venues);
  } catch (e) {
    return Left(ApiFailure(message: e.toString()));
  }
}

  @override
  Future<void> cacheVenues(List<Venue> venues) {
    // TODO: implement cacheVenues
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Venue>>> getCachedVenues() {
    // TODO: implement getCachedVenues
    throw UnimplementedError();
  }
  
  @override
  Future<void> cacheFavoriteVenueIds(List<String> ids) {
    // TODO: implement cacheFavoriteVenueIds
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, List<String>>> getCachedFavoriteVenueIds() {
    // TODO: implement getCachedFavoriteVenueIds
    throw UnimplementedError();
  }


  





}
