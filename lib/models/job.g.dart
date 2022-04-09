// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JobAdapter extends TypeAdapter<Job> {
  @override
  final int typeId = 2;

  @override
  Job read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Job()
      ..categoryColor = fields[0] as int
      ..father = fields[1] as Job?
      ..children = (fields[2] as HiveList?)?.castHiveList()
      ..doneAt = fields[3] as DateTime?
      .._done = fields[4] as bool
      ..points = fields[5] as int?
      ..deadLine = fields[6] as Reminder?
      ..register = fields[7] as TimeRegister?
      ..pathsAudios = (fields[8] as List).cast<PathWNote>()
      ..pathsImages = (fields[9] as List).cast<PathWNote>()
      ..reminder = (fields[10] as List).cast<Reminder>()
      ..note = fields[11] as Note?;
  }

  @override
  void write(BinaryWriter writer, Job obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.categoryColor)
      ..writeByte(1)
      ..write(obj.father)
      ..writeByte(2)
      ..write(obj.children)
      ..writeByte(3)
      ..write(obj.doneAt)
      ..writeByte(4)
      ..write(obj._done)
      ..writeByte(5)
      ..write(obj.points)
      ..writeByte(6)
      ..write(obj.deadLine)
      ..writeByte(7)
      ..write(obj.register)
      ..writeByte(8)
      ..write(obj.pathsAudios)
      ..writeByte(9)
      ..write(obj.pathsImages)
      ..writeByte(10)
      ..write(obj.reminder)
      ..writeByte(11)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
