import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tollo2/models/job.dart';

import 'note.dart';

part 'group.g.dart';

@HiveType(typeId: 1)
class Groups extends HiveObject {
  @HiveField(0)
  int categoryColor = Colors.green.value;
  @HiveField(1)
  List<Job>? jobs=[];
  @HiveField(2)
  Note? note;
}
