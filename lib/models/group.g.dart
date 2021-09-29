// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GroupsAdapter extends TypeAdapter<Groups> {
  @override
  final int typeId = 1;

  @override
  Groups read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Groups()
      ..categoryColor = fields[0] as int
      ..jobs = (fields[1] as List?)?.cast<Job>()
      ..note = fields[2] as Note?;
  }

  @override
  void write(BinaryWriter writer, Groups obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.categoryColor)
      ..writeByte(1)
      ..write(obj.jobs)
      ..writeByte(2)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
