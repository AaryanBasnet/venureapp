// import 'package:dartz/dartz.dart';
// import 'package:venure/core/error/failure.dart';
// import 'package:venure/features/home/data/repository/local_repository/venue_local_repository.dart';
// import 'package:venure/features/home/data/repository/remote_repository/venue_remote_repository.dart';

// import 'package:venure/features/home/domain/entity/venue_entity.dart';
// import 'package:venure/features/home/domain/repository/venue_repository.dart';

// class VenueRepositoryImpl implements IVenueRepository {
//   final VenueRemoteRepository remoteRepo;
//   final VenueLocalRepository localRepo;

//   VenueRepositoryImpl({
//     required this.remoteRepo,
//     required this.localRepo,
//   });

//   @override
//   Future<Either<Failure, List<Venue>>> getAllVenues() async {
//     try {
//       final venues = await remoteRepo.getAllVenues();
//       for (final venue in venues) {
//         await localRepo.addVenue(venue); // cache locally
//       }
//       return Right(venues);
//     } catch (e) {
//       try {
//         final cached = await localRepo.getAllVenues();
//         return Right(cached);
//       } catch (_) {
//         return Left(ApiFailure(message: e.toString()));
//       }
//     }
//   }

//   @override
//   Future<Either<Failure, Venue>> getVenueById(String id) async {
//     try {
//       final venue = await remoteRepo.getVenueById(id);
//       return Right(venue);
//     } catch (e) {
//       try {
//         final cached = await localRepo.getVenueById(id);
//         return Right(cached);
//       } catch (_) {
//         return Left(ApiFailure(message: e.toString()));
//       }
//     }
//   }

//   @override
//   Future<Either<Failure, Venue>> addVenue(Venue venue) async {
//     try {
//       final created = await remoteRepo.addVenue(venue);
//       await localRepo.addVenue(created);
//       return Right(created);
//     } catch (e) {
//       return Left(ApiFailure(message: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, Venue>> updateVenue(Venue venue) async {
//     try {
//       final updated = await remoteRepo.updateVenue(venue);
//       await localRepo.updateVenue(updated);
//       return Right(updated);
//     } catch (e) {
//       return Left(ApiFailure(message: e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, void>> deleteVenue(String id) async {
//     try {
//       await remoteRepo.deleteVenue(id);
//       await localRepo.deleteVenue(id);
//       return const Right(null);
//     } catch (e) {
//       return Left(ApiFailure(message: e.toString()));
//     }
//   }
// }
