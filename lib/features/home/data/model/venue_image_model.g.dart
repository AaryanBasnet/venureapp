// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_image_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VenueImageModelAdapter extends TypeAdapter<VenueImageModel> {
  @override
  final int typeId = 1;

  @override
  VenueImageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VenueImageModel(
      filename: fields[0] as String,
      url: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, VenueImageModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.filename)
      ..writeByte(1)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VenueImageModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VenueImageModel _$VenueImageModelFromJson(Map<String, dynamic> json) =>
    VenueImageModel(
      filename: json['filename'] as String,
      url: json['url'] as String,
    );

Map<String, dynamic> _$VenueImageModelToJson(VenueImageModel instance) =>
    <String, dynamic>{
      'filename': instance.filename,
      'url': instance.url,
    };
