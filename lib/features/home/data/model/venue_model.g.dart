// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VenueModelAdapter extends TypeAdapter<VenueModel> {
  @override
  final int typeId = 9;

  @override
  VenueModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VenueModel(
      id: fields[0] as String,
      ownerId: fields[1] as String,
      venueName: fields[2] as String,
      location: fields[3] as VenueLocationModel,
      capacity: fields[4] as int,
      venueImages: (fields[5] as List).cast<VenueImageModel>(),
      description: fields[6] as String?,
      amenities: (fields[7] as List).cast<String>(),
      pricePerHour: fields[8] as double,
      status: fields[9] as String,
      isDeleted: fields[10] as bool,
      createdAt: fields[11] as DateTime,
      updatedAt: fields[12] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, VenueModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.ownerId)
      ..writeByte(2)
      ..write(obj.venueName)
      ..writeByte(3)
      ..write(obj.location)
      ..writeByte(4)
      ..write(obj.capacity)
      ..writeByte(5)
      ..write(obj.venueImages)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.amenities)
      ..writeByte(8)
      ..write(obj.pricePerHour)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.isDeleted)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VenueModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VenueModel _$VenueModelFromJson(Map<String, dynamic> json) => VenueModel(
      id: json['id'] as String,
      ownerId: json['ownerId'] as String,
      venueName: json['venueName'] as String,
      location:
          VenueLocationModel.fromJson(json['location'] as Map<String, dynamic>),
      capacity: (json['capacity'] as num).toInt(),
      venueImages: (json['venueImages'] as List<dynamic>)
          .map((e) => VenueImageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      description: json['description'] as String?,
      amenities:
          (json['amenities'] as List<dynamic>).map((e) => e as String).toList(),
      pricePerHour: (json['pricePerHour'] as num).toDouble(),
      status: json['status'] as String,
      isDeleted: json['isDeleted'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$VenueModelToJson(VenueModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ownerId': instance.ownerId,
      'venueName': instance.venueName,
      'location': instance.location.toJson(),
      'capacity': instance.capacity,
      'venueImages': instance.venueImages.map((e) => e.toJson()).toList(),
      'description': instance.description,
      'amenities': instance.amenities,
      'pricePerHour': instance.pricePerHour,
      'status': instance.status,
      'isDeleted': instance.isDeleted,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
