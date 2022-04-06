import 'package:hive/hive.dart';
import 'package:tollo2/models/group.dart';
import 'package:tollo2/models/job.dart';
import 'package:tollo2/models/note.dart';


Future<void> openBoxes() async {
  await Hive.openBox<Job>('jobs');
  await Hive.openBox<Groups>('groups');
  await Hive.openBox<Note>('notes');

}
