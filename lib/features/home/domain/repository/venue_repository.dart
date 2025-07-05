import 'package:dartz/dartz.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/home/domain/entity/venue_entity.dart';

abstract interface class IVenueRepository {
  Future<Either<Failure, List<Venue>>> getAllVenues();
  Future<Either<Failure, Venue>> getVenueById(String id);
  Future<Either<Failure, Venue>> addVenue(Venue venue);
  Future<Either<Failure, Venue>> updateVenue(Venue venue);
  Future<Either<Failure, void>> deleteVenue(String id);
}
