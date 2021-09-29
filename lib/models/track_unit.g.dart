// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_unit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimeTrackUnitAdapter extends TypeAdapter<TimeTrackUnit> {
  @override
  final int typeId = 7;

  @override
  TimeTrackUnit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimeTrackUnit()
      ..note = fields[0] as Note?
      ..begin = fields[1] as DateTime
      ..end = fields[2] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, TimeTrackUnit obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.note)
      ..writeByte(1)
      ..write(obj.begin)
      ..writeByte(2)
      ..write(obj.end);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeTrackUnitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
