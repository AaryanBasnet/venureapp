import 'package:venure/features/home/data/data_source/ivenue_data_source.dart';
import 'package:venure/features/home/domain/entity/venue_entity.dart';
import 'package:venure/features/home/data/model/venue_model.dart';
import 'package:venure/core/network/hive_service.dart';

class VenueLocalDataSource implements IVenueDataSource {
  final HiveService _hiveService;

  VenueLocalDataSource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<List<Venue>> getAllVenues() async {
    final models = _hiveService.getAllVenues();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Venue> getVenueById(String id) async {
    final model = _hiveService.getVenueById(id);
    if (model == null) {
      throw Exception('Venue with ID $id not found');
    }
    return model.toEntity();
  }

  @override
  Future<Venue> addVenue(Venue venue) async {
    final model = VenueModel.fromEntity(venue);
    await _hiveService.saveVenue(model);
    return venue;
  }

  @override
  Future<Venue> updateVenue(Venue venue) async {
    final model = VenueModel.fromEntity(venue);
    await _hiveService.updateVenue(model);
    return venue;
  }

  @override
  Future<void> deleteVenue(String id) async {
    await _hiveService.deleteVenue(id);
  }

  @override
  Future<List<String>> getFavoriteVenueIds() async {
    return _hiveService.getFavoriteVenueIds();
  }

  @override
  Future<bool> toggleFavoriteVenue(String venueId) async {
    return await _hiveService.toggleFavoriteVenue(venueId);
  }

  @override
  Future<List<Venue>> getFavoriteVenues() async {
    final favoriteIds = _hiveService.getFavoriteVenueIds();
    final allVenues = await getAllVenues();

    return allVenues.where((venue) => favoriteIds.contains(venue.id)).toList();
  }

  Future<void> saveAllVenues(List<Venue> venues) async {
    for (final venue in venues) {
      final model = VenueModel.fromEntity(venue); // Convert entity to model
      await _hiveService.saveVenue(model);
    }
  }

  Future<void> saveFavoriteVenueIds(List<String> ids) async {
  await _hiveService.saveFavoriteVenueIds(ids);
}


  

  @override
  Future<List<Venue>> searchVenues({
    String? search,
    String? city,
    String? capacityRange,
    List<String>? amenities,
    String? sort,
    int page = 1,
    int limit = 6,
  }) async {
    final allVenues = await getAllVenues();

    var filtered =
        allVenues.where((venue) {
          final matchesSearch =
              search == null ||
              venue.venueName.toLowerCase().contains(search.toLowerCase());
          final matchesCity =
              city == null ||
              venue.location.city.toLowerCase() == city.toLowerCase();
          final matchesAmenities =
              amenities == null ||
              amenities.every((a) => venue.amenities.contains(a));
          final matchesCapacity =
              capacityRange == null ||
              _checkCapacity(venue.capacity, capacityRange);
          return matchesSearch &&
              matchesCity &&
              matchesAmenities &&
              matchesCapacity;
        }).toList();

    if (sort == 'price') {
      filtered.sort((a, b) => a.pricePerHour.compareTo(b.pricePerHour));
    }

    final start = (page - 1) * limit;
    return filtered.skip(start).take(limit).toList();
  }

  bool _checkCapacity(int capacity, String range) {
    final parts = range.split('-');
    if (parts.length != 2) return true;
    final min = int.tryParse(parts[0]) ?? 0;
    final max = int.tryParse(parts[1]) ?? 9999;
    return capacity >= min && capacity <= max;
  }
}
