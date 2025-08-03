import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:venure/features/home/domain/entity/venue_location_entity.dart';

part 'venue_location_model.g.dart';

@HiveType(typeId: 2)
@JsonSerializable()
class VenueLocationModel extends VenueLocation with HiveObjectMixin {
  @override
  @HiveField(0)
  final String address;

  @override
  @HiveField(1)
  final String city;

  @override
  @HiveField(2)
  final String state;

  @override
  @HiveField(3)
  final String country;

  VenueLocationModel({
    required this.address,
    required this.city,
    required this.state,
    required this.country,
  }) : super(address: address, city: city, state: state, country: country);

  /// Safely parse location values with null fallback
  factory VenueLocationModel.fromJson(Map<String, dynamic> json) {
    return VenueLocationModel(
      address: json['address']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => _$VenueLocationModelToJson(this);

  factory VenueLocationModel.fromEntity(VenueLocation entity) {
    return VenueLocationModel(
      address: entity.address,
      city: entity.city,
      state: entity.state,
      country: entity.country,
    );
  }

  VenueLocation toEntity() {
    return VenueLocation(
      address: address,
      city: city,
      state: state,
      country: country,
    );
  }
}
