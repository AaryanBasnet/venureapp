import 'package:dartz/dartz.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/home/data/data_source/ivenue_data_source.dart';
import 'package:venure/features/home/data/data_source/remote_data_source/venue_remote_datasource.dart';
import 'package:venure/features/home/domain/entity/venue_entity.dart';
import 'package:venure/features/home/domain/repository/venue_repository.dart';

class VenueRemoteRepository implements IVenueRepository {
  final VenueRemoteDataSource remoteDataSource;

  VenueRemoteRepository({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Venue>>> getAllVenues() async {
    try {
      final venues = await remoteDataSource.getAllVenues();
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
}
