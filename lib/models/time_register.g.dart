// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_register.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimeRegisterAdapter extends TypeAdapter<TimeRegister> {
  @override
  final int typeId = 6;

  @override
  TimeRegister read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimeRegister()
      ..stateOn = fields[0] as bool
      ..register = (fields[1] as List).cast<TimeTrackUnit>();
  }

  @override
  void write(BinaryWriter writer, TimeRegister obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.stateOn)
      ..writeByte(1)
      ..write(obj.register);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeRegisterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
