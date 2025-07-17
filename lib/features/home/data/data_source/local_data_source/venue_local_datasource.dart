import 'package:venure/features/home/data/data_source/ivenue_data_source.dart';
import 'package:venure/features/home/domain/entity/venue_entity.dart';
import 'package:venure/features/home/data/model/venue_model.dart';
import 'package:venure/core/network/hive_service.dart';

class VenueLocalDataSource implements IVenueDataSource {
  final HiveService _hiveService;
  List<String> _cachedFavorites = [];

  VenueLocalDataSource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<List<Venue>> getAllVenues() async {
    final models = await _hiveService.getAllVenues();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Venue> getVenueById(String id) async {
    final model = await _hiveService.getVenueById(id);
    return model!.toEntity();
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
    // Return cached list instantly
    if (_cachedFavorites.isEmpty) {
      _cachedFavorites = await _hiveService.getFavoriteVenueIds();
    }
    return _cachedFavorites;
  }

  @override
  Future<bool> toggleFavoriteVenue(String venueId) async {
    if (_cachedFavorites.contains(venueId)) {
      _cachedFavorites.remove(venueId);
    } else {
      _cachedFavorites.add(venueId);
    }

    // Persist asynchronously, don't wait here
    _hiveService.saveFavoriteVenueIds(_cachedFavorites);

    // Return immediately based on updated cache
    return _cachedFavorites.contains(venueId);
  }

  @override
  Future<List<Venue>> getFavoriteVenues() async {
    if (_cachedFavorites.isEmpty) {
      _cachedFavorites = await _hiveService.getFavoriteVenueIds();
    }

    final allVenues = await getAllVenues();

    return allVenues
        .where((venue) => _cachedFavorites.contains(venue.id))
        .toList();
  }
}
