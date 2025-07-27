import 'package:dio/dio.dart';
import 'package:venure/app/constant/api/api_endpoints.dart';
import 'package:venure/core/network/api_service.dart';
import 'package:venure/features/home/data/data_source/ivenue_data_source.dart';
import 'package:venure/features/home/data/model/venue_model.dart';
import 'package:venure/features/home/domain/entity/venue_entity.dart';

class VenueRemoteDataSource implements IVenueDataSource {
  final ApiService apiService;

  VenueRemoteDataSource({required this.apiService});

  @override
  Future<List<Venue>> getAllVenues({int page = 1, int limit = 5}) async {
    try {
      final params = <String, dynamic>{
        'page': page.toString(),
        'limit': limit.toString(),
      };
      final response = await apiService.dio.get(
        ApiEndpoints.getApprovedVenues,
        queryParameters: params,
      );
      final List data = response.data['data'] as List;
      return data.map((e) => VenueModel.fromJson(e).toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to fetch venues: $e');
    }
  }

  @override
  Future<Venue> getVenueById(String id) async {
    try {
      final response = await apiService.get(ApiEndpoints.getVenueById(id));
      // Extract nested data from response
      final venueJson = response.data['data'];
      return VenueModel.fromJson(venueJson).toEntity();
    } catch (e) {
      throw Exception('Failed to fetch venue: $e');
    }
  }

  @override
  Future<Venue> addVenue(Venue venue) async {
    try {
      final response = await apiService.dio.post(
        '/venues',
        data: VenueModel.fromEntity(venue).toJson(),
      );
      return VenueModel.fromJson(response.data).toEntity();
    } catch (e) {
      throw Exception('Failed to add venue: $e');
    }
  }

  @override
  Future<Venue> updateVenue(Venue venue) async {
    try {
      final response = await apiService.dio.put(
        '/venues/${venue.id}',
        data: VenueModel.fromEntity(venue).toJson(),
      );
      return VenueModel.fromJson(response.data).toEntity();
    } catch (e) {
      throw Exception('Failed to update venue: $e');
    }
  }

  @override
  Future<void> deleteVenue(String id) async {
    try {
      final response = await apiService.dio.delete('/venues/$id');
      if (response.statusCode != 204) {
        throw Exception('Failed to delete venue');
      }
    } catch (e) {
      throw Exception('Failed to delete venue: $e');
    }
  }

  @override
  Future<List<String>> getFavoriteVenueIds() async {
    final response = await apiService.get(
      ApiEndpoints.getFavoriteVenues,
      requiresAuth: true,
    );
    final data = response.data;

    if (data['success'] == true && data['favorites'] is List) {
      final favoritesList = data['favorites'] as List;
      return favoritesList.map<String>((fav) => fav['_id'] as String).toList();
    } else {
      throw Exception(data['msg'] ?? 'Failed to fetch favorite venues');
    }
  }

  @override
  Future<bool> toggleFavoriteVenue(String venueId) async {
    final path = '${ApiEndpoints.toggleFavorite}/$venueId';
    final response = await apiService.post(path, null, requiresAuth: true);

    if (response.data['success'] == true) {
      // Extract new favorite status from API if present
      if (response.data.containsKey('isFavorite')) {
        final isFavorite = response.data['isFavorite'];
        if (isFavorite is bool) {
          return isFavorite;
        }
      }
      // Fallback
      return true;
    } else {
      throw Exception("Failed to toggle favorite");
    }
  }

  @override
  Future<List<Venue>> getFavoriteVenues() async {
    try {
      final response = await apiService.get(
        ApiEndpoints.getFavoriteVenuesList,
        requiresAuth: true,
      );

      final data = response.data;

      if (data['success'] == true && data['venues'] is List) {
        final venuesList = data['venues'] as List;
        return venuesList
            .map((e) => VenueModel.fromJson(e).toEntity())
            .toList();
      } else {
        throw Exception(data['msg'] ?? 'Failed to fetch favorite venues');
      }
    } catch (e) {
      throw Exception('Failed to fetch favorite venues: $e');
    }
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
    try {
      final params = <String, dynamic>{
        if (search != null) 'search': search,
        if (city != null) 'city': city,
        if (capacityRange != null) 'capacityRange': capacityRange,
        if (amenities != null && amenities.isNotEmpty)
          'amenities': amenities.join(','),
        if (sort != null) 'sort': sort,
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final response = await apiService.dio.get(
        ApiEndpoints.getApprovedVenues,
        queryParameters: params,
      );

      final data = response.data['data'] as List;
      return data.map((e) => VenueModel.fromJson(e).toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to search venues: $e');
    }
  }
}
