import 'package:dartz/dartz.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/home/data/data_source/ivenue_data_source.dart';
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
}
