import 'package:hive/hive.dart';
import 'package:tollo2/models/duration.g.dart';
import 'package:tollo2/models/group.dart';
import 'package:tollo2/models/job.dart';
import 'package:tollo2/models/note.dart';
import 'package:tollo2/models/reminder.dart';
import 'package:tollo2/models/reward.dart';
import 'package:tollo2/models/time_register.dart';
import 'package:tollo2/models/track_unit.dart';

void adapterRegistration() {
  Hive.registerAdapter(DurationAdapter());
  Hive.registerAdapter(TimeTrackUnitAdapter());
  Hive.registerAdapter(TimeRegisterAdapter());
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(ReminderAdapter());
  Hive.registerAdapter(RewardAdapter());
  Hive.registerAdapter(JobAdapter());
  Hive.registerAdapter(GroupsAdapter());
}
