import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/home/domain/repository/venue_repository.dart';

class ToggleFavoriteUseCase extends Equatable {
  final IVenueRepository repository;
  const ToggleFavoriteUseCase(this.repository);

  Future<Either<Failure, bool>> call(String venueId) {
    return repository.toggleFavorite(venueId);
  }

  @override
  List<Object?> get props => [repository];
}
