// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pathWithNote.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PathWNoteAdapter extends TypeAdapter<PathWNote> {
  @override
  final int typeId = 8;

  @override
  PathWNote read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PathWNote(
      fields[2] as String,
    )
      ..note = fields[0] as String
      ..createdAt = fields[1] as DateTime;
  }

  @override
  void write(BinaryWriter writer, PathWNote obj) {
    writer
      ..writeByte(3)
      ..writeByte(2)
      ..write(obj.path)
      ..writeByte(0)
      ..write(obj.note)
      ..writeByte(1)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PathWNoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
