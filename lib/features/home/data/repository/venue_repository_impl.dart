// import 'package:dartz/dartz.dart';
// import 'package:venure/core/error/failure.dart';
// import 'package:venure/features/home/data/data_source/ivenue_data_source.dart';
// import 'package:venure/features/home/data/data_source/local_data_source/venue_local_datasource.dart';
// import 'package:venure/features/home/data/data_source/remote_data_source/venue_remote_datasource.dart';
// import 'package:venure/features/home/domain/entity/venue_entity.dart';
// import 'package:venure/features/home/domain/repository/venue_repository.dart';

// class VenueRepositoryImpl implements IVenueRepository {
//   final VenueRemoteDataSource remoteDataSource;
//   final VenueLocalDataSource localDataSource;

//   VenueRepositoryImpl({
//     required this.remoteDataSource,
//     required this.localDataSource,
//   });

//   @override
//   Future<Either<Failure, List<Venue>>> getAllVenues() async {
//     try {
//       final remoteVenues = await remoteDataSource.getAllVenues();

//       // Cache to local DB for offline support
//       for (var venue in remoteVenues) {
//         await localDataSource.addVenue(venue);
//       }

//       return Right(remoteVenues);
//     } catch (e) {
//       // Fallback to local cache if remote fails
//       try {
//         final localVenues = await localDataSource.getAllVenues();
//         return Right(localVenues);
//       } catch (localError) {
//         return Left(ApiFailure(message: e.toString()));
//       }
//     }
//   }

//   @override
//   Future<Either<Failure, Venue>> getVenueById(String id) async {
//     try {
//       final venue = await remoteDataSource.getVenueById(id);
//       await localDataSource.updateVenue(venue);
//       return Right(venue);
//     } catch (e) {
//       try {
//         final venue = await localDataSource.getVenueById(id);
//         return Right(venue);
//       } catch (localError) {
//         return Left(ApiFailure(message: e.toString()));
//       }
//     }
//   }

//   @override
//   Future<Either<Failure, Venue>> addVenue(Venue venue) async {
//     try {
//       final newVenue = await remoteDataSource.addVenue(venue);
//       await localDataSource.addVenue(newVenue);
//       return Right(newVenue);
//     } catch (e) {
//       return Left(ApiFailure(message: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, Venue>> updateVenue(Venue venue) async {
//     try {
//       final updatedVenue = await remoteDataSource.updateVenue(venue);
//       await localDataSource.updateVenue(updatedVenue);
//       return Right(updatedVenue);
//     } catch (e) {
//       return Left(ApiFailure(message: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, void>> deleteVenue(String id) async {
//     try {
//       await remoteDataSource.deleteVenue(id);
//       await localDataSource.deleteVenue(id);
//       return const Right(null);
//     } catch (e) {
//       return Left(ApiFailure(message: e.toString()));
//     }
//   }

//   // Add favorites methods (assuming you updated IVenueRepository):

//   @override
//   Future<Either<Failure, List<String>>> getFavorites() async {
//     try {
//       final favorites = await remoteDataSource.getFavoriteVenueIds();
//       await localDataSource.saveFavorites(favorites);
//       return Right(favorites);
//     } catch (e) {
//       // fallback to local if remote fails
//       try {
//         final localFavorites = await localDataSource.getFavoriteVenueIds();
//         return Right(localFavorites);
//       } catch (localError) {
//         return Left(ApiFailure(message: e.toString()));
//       }
//     }
//   }

//   @override
//   Future<Either<Failure, bool>> toggleFavorite(String venueId) async {
//     try {
//       final toggled = await remoteDataSource.toggleFavoriteVenue(venueId);
//       if (toggled) {
//         await localDataSource.toggleFavoriteVenue(venueId);
//       }
//       return Right(toggled);
//     } catch (e) {
//       return Left(ApiFailure(message: e.toString()));
//     }
//   }
// }
