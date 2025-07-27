import 'package:dartz/dartz.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/home/data/repository/local_repository/venue_local_repository.dart';
import 'package:venure/features/home/domain/entity/venue_entity.dart';
import 'package:venure/features/home/domain/repository/venue_repository.dart';

class HybridVenueRepository implements IVenueRepository {
  final IVenueRepository remoteRepository;
  final VenueLocalRepository localRepository;

  HybridVenueRepository({
    required this.remoteRepository,
    required this.localRepository,
  });

  @override
  Future<Either<Failure, List<Venue>>> getAllVenues({
    int page = 1,
    int limit = 5,
  }) async {
    final remoteResult = await remoteRepository.getAllVenues(
      page: page,
      limit: limit,
    );

    if (remoteResult.isRight()) {
      final venues = remoteResult.getOrElse(() => []);
      await localRepository.cacheVenues(
        venues,
      ); 
     
      final allCached = await localRepository.getAllVenues();
      allCached.fold(
        (l) => print("❌ Failed to read from Hive after caching: $l"),
        (r) => print("✅ Cached venues in Hive: ${r.length}"),
      );

      return Right(venues);
    }

    final localResult = await localRepository.getAllVenues();

    if (localResult.isRight()) {
      print(
        "📦 Using cached venues from Hive: ${localResult.getOrElse(() => []).length}",
      );
      return localResult;
    }

    return remoteResult; 
  }

  @override
  Future<Either<Failure, Venue>> getVenueById(String id) async {
    final remoteResult = await remoteRepository.getVenueById(id);

    if (remoteResult.isRight()) {
      final venue = remoteResult.getOrElse(() => throw Exception());
      await localRepository.addVenue(venue); // Cache
      return Right(venue);
    }

    // Fallback to local
    final localResult = await localRepository.getVenueById(id);
    return localResult;
  }

  @override
  Future<Either<Failure, bool>> toggleFavorite(String venueId) async {
    final remoteResult = await remoteRepository.toggleFavorite(venueId);

    return await remoteResult.fold(
      (failure) async {
        print(
          "❌ Failed to toggle favorite remotely: $failure. Using local fallback.",
        );
        // Optionally fallback to local toggle for offline mode
        return await localRepository.toggleFavorite(venueId);
      },
      (isFavorited) async {
        // Sync local cache with backend state
        final localResult = await localRepository.toggleFavorite(venueId);
        localResult.fold(
          (localFail) =>
              print("⚠️ Failed to toggle favorite locally: $localFail"),
          (localSuccess) =>
              print("✅ Toggled favorite locally to: $localSuccess"),
        );
        return Right(isFavorited);
      },
    );
  }

  @override
  Future<Either<Failure, List<Venue>>> getFavoriteVenues() {
    return localRepository.getFavoriteVenues();
  }

  @override
  Future<Either<Failure, Venue>> addVenue(Venue venue) async {
    final remoteResult = await remoteRepository.addVenue(venue);

    return remoteResult.fold((failure) => Left(failure), (addedVenue) async {
      // Cache locally after successful remote add
      await localRepository.addVenue(addedVenue);
      return Right(addedVenue);
    });
  }

  @override
  Future<Either<Failure, void>> deleteVenue(String id) {
    return remoteRepository.deleteVenue(id);
  }

  @override
  Future<Either<Failure, Venue>> updateVenue(Venue venue) {
    return remoteRepository.updateVenue(venue);
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
    final remoteResult = await remoteRepository.searchVenues(
      search: search,
      city: city,
      capacityRange: capacityRange,
      amenities: amenities,
      sort: sort,
      page: page,
      limit: limit,
    );

    if (remoteResult.isRight()) {
      return remoteResult;
    }

    // Fallback to local search if remote fails
    final localResult = await localRepository.searchVenues(
      search: search,
      city: city,
      capacityRange: capacityRange,
      amenities: amenities,
      sort: sort,
      page: page,
      limit: limit,
    );

    return localResult;
  }

  @override
  Future<Either<Failure, List<Venue>>> getVenuesByIds(List<String> ids) {
    return remoteRepository.getVenuesByIds(ids);
  }

  @override
  Future<Either<Failure, List<Venue>>> getCachedVenues() async {
    // Delegate to local repository to get cached venues
    return await localRepository.getAllVenues();
  }

  @override
  Future<void> cacheVenues(List<Venue> venues) async {
    // Delegate to local repository to save venues in cache
    await localRepository.saveAllVenues(venues);
  }

  @override
  Future<Either<Failure, List<String>>> getFavorites() async {
    final remoteResult = await remoteRepository.getFavorites();

    return remoteResult.fold(
      (failure) async {
        print("❌ API favorites failed, using cached favorites.");
        return await localRepository.getCachedFavoriteVenueIds();
      },
      (favoriteIds) async {
        await localRepository.cacheFavoriteVenueIds(favoriteIds);
        print("✅ Fetched & cached favorite IDs: ${favoriteIds}");
        return Right(favoriteIds);
      },
    );
  }

  @override
  Future<void> cacheFavoriteVenueIds(List<String> ids) async {
    await localRepository.cacheFavoriteVenueIds(ids);
    print("🟢 HybridVenueRepository: Cached favorite venue IDs: $ids");
  }

  @override
  Future<Either<Failure, List<String>>> getCachedFavoriteVenueIds() async {
    final result = await localRepository.getCachedFavoriteVenueIds();
    result.fold(
      (failure) => print(
        "🔴 HybridVenueRepository: Failed to get cached favorite IDs: $failure",
      ),
      (ids) => print(
        "🟢 HybridVenueRepository: Retrieved cached favorite IDs: $ids",
      ),
    );
    return result;
  }
}
