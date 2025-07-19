import 'package:dartz/dartz.dart';
import 'package:venure/core/error/failure.dart';
import 'package:venure/features/home/domain/entity/venue_entity.dart';
import 'package:venure/features/home/domain/repository/venue_repository.dart';

class SearchVenuesUseCase {
  final IVenueRepository venueRepository;

  SearchVenuesUseCase(this.venueRepository);

  Future<Either<Failure, List<Venue>>> call({
    String? searchQuery,
    String? city,
    String? capacityRange,
    List<String>? amenities,
    String? sort,
    int page = 1,
    int limit = 10,
  }) {
    return venueRepository.searchVenues(
      search: searchQuery,
      city: city,
      capacityRange: capacityRange,
      amenities: amenities,
      sort: sort,
      page: page,
      limit: limit,
    );
  }
}
