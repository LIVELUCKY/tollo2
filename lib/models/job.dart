import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tollo2/models/reminder.dart';
import 'package:tollo2/models/track_unit.dart';
import 'package:tollo2/services/files_handling/delete_file.dart';

import 'note.dart';
import 'time_register.dart';

part 'job.g.dart';

@HiveType(typeId: 2)
class Job extends HiveObject {
  @HiveField(0)
  int categoryColor = Colors.green.value;
  @HiveField(1)
  Job? father;
  @HiveField(2)
  HiveList<Job>? children;
  @HiveField(3)
  DateTime? doneAt;
  @HiveField(4)
  bool _done = false;
  @HiveField(5)
  int? points;
  @HiveField(6)
  Reminder? deadLine;
  @HiveField(7)
  TimeRegister? register;
  @HiveField(8)
  List<String> pathsAudios = [];
  @HiveField(9)
  List<String> pathsImages = [];
  @HiveField(10)
  List<Reminder> reminder=[];
  @HiveField(11)
  Note? note;

  bool get done {
    if (children!.where((element) => element.done == false).toList().length !=
        0)
      return false && _done;
    else {
      return _done;
    }
  }

  set done(bool value) {
    if (children != null ||
        children!.where((element) => element.done != true).toList().length ==
            0) {
      _done = value;
      doneAt = DateTime.now();
    }
  }

  Duration getElapsedAll() {
    if (register == null) return Duration.zero;
    Duration aux = register!.getElapsedAllInRegister();
    if (children != null) {
      for (Job j in children!) {
        aux += j.getElapsedAll();
      }
    }
    return aux;
  }

  int getValidMaximumPoints() {
    if (points == null) return 0;
    return points! -
        (children!.fold(
            0,
            (previousValue, element) =>
                previousValue + element.getValidMaximumPoints()));
  }

  int getChildrenLength() {
    if (children == null) return 0;
    return children!.length +
        children!.fold(
            0,
            (previousValue, element) =>
                previousValue + element.getChildrenLength());
  }

  Future<void> deleteAll() async {
    for (String s in pathsImages) {
      await deleteFile(s);
    }
    for (String s in pathsAudios) {
      await deleteFile(s);
    }
    if (children != null) {
      for (Job j in children!) {
        await j.deleteAll();
      }
    }
  }

  List<TimeTrackUnit> getAllTimeUnits(){
    List<TimeTrackUnit> aux=register!.register;
    if (children != null) {
      for (Job j in children!) {
        aux += j.getAllTimeUnits();
      }
    }
    return aux;
  }
}
