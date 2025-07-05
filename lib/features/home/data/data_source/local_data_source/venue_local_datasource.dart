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
    final models = await _hiveService.getAllVenues();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Venue> getVenueById(String id) async {
    final model = await _hiveService.getVenueById(id);
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
}
