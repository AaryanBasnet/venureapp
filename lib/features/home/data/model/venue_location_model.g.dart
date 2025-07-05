// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_location_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VenueLocationModelAdapter extends TypeAdapter<VenueLocationModel> {
  @override
  final int typeId = 2;

  @override
  VenueLocationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VenueLocationModel(
      address: fields[0] as String,
      city: fields[1] as String,
      state: fields[2] as String,
      country: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, VenueLocationModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.address)
      ..writeByte(1)
      ..write(obj.city)
      ..writeByte(2)
      ..write(obj.state)
      ..writeByte(3)
      ..write(obj.country);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VenueLocationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VenueLocationModel _$VenueLocationModelFromJson(Map<String, dynamic> json) =>
    VenueLocationModel(
      address: json['address'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      country: json['country'] as String,
    );

Map<String, dynamic> _$VenueLocationModelToJson(VenueLocationModel instance) =>
    <String, dynamic>{
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
    };
