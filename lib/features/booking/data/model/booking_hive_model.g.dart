// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookingHiveModelAdapter extends TypeAdapter<BookingHiveModel> {
  @override
  final int typeId = 3;

  @override
  BookingHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookingHiveModel(
      id: fields[0] as String,
      venue: fields[1] as String,
      bookingDate: fields[2] as DateTime,
      timeSlot: fields[3] as String,
      hoursBooked: fields[4] as int,
      numberOfGuests: fields[5] as int,
      eventType: fields[6] as String,
      specialRequirements: fields[7] as String,
      contactName: fields[8] as String,
      phoneNumber: fields[9] as String,
      selectedAddonsJson: (fields[10] as List).cast<String>(),
      totalPrice: fields[11] as int,
      paymentDetailsJson: fields[12] as String,
      status: fields[13] as String,
      customer: fields[14] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BookingHiveModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.venue)
      ..writeByte(2)
      ..write(obj.bookingDate)
      ..writeByte(3)
      ..write(obj.timeSlot)
      ..writeByte(4)
      ..write(obj.hoursBooked)
      ..writeByte(5)
      ..write(obj.numberOfGuests)
      ..writeByte(6)
      ..write(obj.eventType)
      ..writeByte(7)
      ..write(obj.specialRequirements)
      ..writeByte(8)
      ..write(obj.contactName)
      ..writeByte(9)
      ..write(obj.phoneNumber)
      ..writeByte(10)
      ..write(obj.selectedAddonsJson)
      ..writeByte(11)
      ..write(obj.totalPrice)
      ..writeByte(12)
      ..write(obj.paymentDetailsJson)
      ..writeByte(13)
      ..write(obj.status)
      ..writeByte(14)
      ..write(obj.customer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
