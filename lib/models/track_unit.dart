import 'package:flutter/src/material/date.dart';
import 'package:hive/hive.dart';

import 'note.dart';
part 'track_unit.g.dart';

@HiveType(typeId: 7)
class TimeTrackUnit extends HiveObject {
  @HiveField(0)
  Note? note;
  @HiveField(1)
  DateTime begin=DateTime.now();
  @HiveField(2)
  DateTime? end;

  Duration duration() {
    if (end == null) return DateTime.now().difference(begin);
    return end!.difference(begin);
  }


}
