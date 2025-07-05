import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/home/domain/entity/venue_entity.dart';
import 'package:venure/features/home/domain/repository/venue_repository.dart';

class GetAllVenuesUseCase extends Equatable {
  final IVenueRepository repository;

  const GetAllVenuesUseCase(this.repository);

  Future<Either<Failure, List<Venue>>> call() async {
    return await repository.getAllVenues();
  }

  @override
  List<Object?> get props => [repository];
}
