import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'venue_location_model.dart';
import 'venue_image_model.dart';
import '../../domain/entity/venue_entity.dart';

part 'venue_model.g.dart';

@HiveType(typeId: 9)
@JsonSerializable(explicitToJson: true)
class VenueModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String ownerId;

  @HiveField(2)
  final String venueName;

  @HiveField(3)
  final VenueLocationModel location;

  @HiveField(4)
  final int capacity;

  @HiveField(5)
  final List<VenueImageModel> venueImages;

  @HiveField(6)
  final String? description;

  @HiveField(7)
  final List<String> amenities;

  @HiveField(8)
  final double pricePerHour;

  @HiveField(9)
  final String status;

  @HiveField(10)
  final bool isDeleted;

  @HiveField(11)
  final DateTime createdAt;

  @HiveField(12)
  final DateTime updatedAt;

  VenueModel({
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

  /// 🔥 SAFELY PARSE RAW JSON FROM BACKEND
  factory VenueModel.fromJson(Map<String, dynamic> json) {
    return VenueModel(
      id: json['_id']?.toString() ?? '',
      ownerId: json['owner']?.toString() ?? '',
      venueName: json['venueName']?.toString() ?? '',
      location: VenueLocationModel.fromJson(
          json['location'] as Map<String, dynamic>? ?? {}),
      capacity: json['capacity'] is int
          ? json['capacity']
          : int.tryParse(json['capacity']?.toString() ?? '0') ?? 0,
      venueImages: (json['venueImages'] as List<dynamic>? ?? [])
          .map((e) =>
              VenueImageModel.fromJson(e as Map<String, dynamic>? ?? {}))
          .toList(),
      description: json['description']?.toString(),
      amenities: (json['amenities'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      pricePerHour: (json['pricePerHour'] as num?)?.toDouble() ??
          double.tryParse(json['pricePerHour']?.toString() ?? '0') ??
          0.0,
      status: json['status']?.toString() ?? '',
      isDeleted: json['isDeleted'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  /// ✅ SERIALIZE BACK TO JSON
  Map<String, dynamic> toJson() => _$VenueModelToJson(this);

  factory VenueModel.fromEntity(Venue entity) {
    return VenueModel(
      id: entity.id,
      ownerId: entity.ownerId,
      venueName: entity.venueName,
      location: VenueLocationModel.fromEntity(entity.location),
      capacity: entity.capacity,
      venueImages:
          entity.venueImages.map((e) => VenueImageModel.fromEntity(e)).toList(),
      description: entity.description,
      amenities: entity.amenities,
      pricePerHour: entity.pricePerHour,
      status: entity.status,
      isDeleted: entity.isDeleted,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Venue toEntity() {
    return Venue(
      id: id,
      ownerId: ownerId,
      venueName: venueName,
      location: location.toEntity(),
      capacity: capacity,
      venueImages: venueImages.map((e) => e.toEntity()).toList(),
      description: description,
      amenities: amenities,
      pricePerHour: pricePerHour,
      status: status,
      isDeleted: isDeleted,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
