import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entity/venue_image_entity.dart';

part 'venue_image_model.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class VenueImageModel extends VenueImage with HiveObjectMixin {
  @override
  @HiveField(0)
  final String filename;

  @override
  @HiveField(1)
  final String url;

  VenueImageModel({
    required this.filename,
    required this.url,
  }) : super(filename: filename, url: url);

  /// Safely parse even if fields are missing or null
  factory VenueImageModel.fromJson(Map<String, dynamic> json) {
    return VenueImageModel(
      filename: json['filename']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => _$VenueImageModelToJson(this);

  factory VenueImageModel.fromEntity(VenueImage entity) {
    return VenueImageModel(
      filename: entity.filename,
      url: entity.url,
    );
  }

  VenueImage toEntity() {
    return VenueImage(filename: filename, url: url);
  }
}
