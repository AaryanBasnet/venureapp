// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatModelAdapter extends TypeAdapter<ChatModel> {
  @override
  final int typeId = 4;

  @override
  ChatModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatModel(
      id: fields[0] as String,
      participants: (fields[1] as List).cast<Participant>(),
      venueId: fields[2] as String,
      venueName: fields[3] as String?,
      lastMessage: fields[4] as String?,
      unreadCount: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ChatModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.participants)
      ..writeByte(2)
      ..write(obj.venueId)
      ..writeByte(3)
      ..write(obj.venueName)
      ..writeByte(4)
      ..write(obj.lastMessage)
      ..writeByte(5)
      ..write(obj.unreadCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ParticipantAdapter extends TypeAdapter<Participant> {
  @override
  final int typeId = 5;

  @override
  Participant read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Participant(
      id: fields[0] as String,
      name: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Participant obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParticipantAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
