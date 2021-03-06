// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReminderAdapter extends TypeAdapter<Reminder> {
  @override
  final int typeId = 4;

  @override
  Reminder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Reminder()
      ..clockBegin = fields[0] as DateTime?
      ..remindMe = fields[1] as bool;
  }

  @override
  void write(BinaryWriter writer, Reminder obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.clockBegin)
      ..writeByte(1)
      ..write(obj.remindMe);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
