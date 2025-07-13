

import 'package:dartz/dartz.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/home/domain/entity/venue_entity.dart';
import 'package:venure/features/home/domain/repository/venue_repository.dart';

class GetFavoriteVenuesUseCase {
  final IVenueRepository repository;
  GetFavoriteVenuesUseCase(this.repository);

  Future<Either<Failure, List<Venue>>> call() {
    return repository.getFavoriteVenues();
  }
}
