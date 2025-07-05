import 'package:equatable/equatable.dart';
import 'package:venure/features/home/domain/entity/venue_image_entity.dart';
import 'package:venure/features/home/domain/entity/venue_location_entity.dart';


class Venue extends Equatable {//
  final String id;
  final String ownerId;
  final String venueName;
  final VenueLocation location;
  final int capacity;
  final List<VenueImage> venueImages;
  final String? description;
  final List<String> amenities;
  final double pricePerHour;
  final String status;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Venue({
    required this.id,
    required this.ownerId,
    required this.venueName,
    required this.location,
    required this.capacity,
    required this.venueImages,
    this.description,
    required this.amenities,
    required this.pricePerHour,
    required this.status,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        ownerId,
        venueName,
        location,
        capacity,
        venueImages,
        description,
        amenities,
        pricePerHour,
        status,
        isDeleted,
        createdAt,
        updatedAt,
      ];
}
