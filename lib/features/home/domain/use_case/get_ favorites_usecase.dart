import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/home/domain/repository/venue_repository.dart';

class GetFavoritesUseCase extends Equatable {
  final IVenueRepository repository;

  const GetFavoritesUseCase(this.repository);

  Future<Either<Failure, List<String>>> call() {
    return repository.getFavorites();
  }

  @override
  List<Object?> get props => [repository];
}
