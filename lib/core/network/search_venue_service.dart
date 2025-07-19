import 'package:dio/dio.dart';
import 'package:venure/app/constant/api/api_endpoints.dart';

import 'package:venure/features/home/data/model/venue_model.dart';

class SearchVenueService {
  final Dio dio;

  SearchVenueService(this.dio);

  Future<List<VenueModel>> searchVenues({
    String? search,
    String? city,
    String? capacityRange,
    List<String>? amenities,
    String? sort,
    int page = 1,
    int limit = 6,
  }) async {
    final params = {
      if (search != null) 'search': search,
      if (city != null) 'city': city,
      if (capacityRange != null) 'capacityRange': capacityRange,
      if (amenities != null) 'amenities': amenities.join(','),
      if (sort != null) 'sort': sort,
      'page': page.toString(),
      'limit': limit.toString(),
    };

    final response = await dio.get(ApiEndpoints.getApprovedVenues, queryParameters: params);

    final List data = response.data['data'];
    return data.map((e) => VenueModel.fromJson(e)).toList();
  }
}
