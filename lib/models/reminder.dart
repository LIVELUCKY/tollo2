import 'package:hive/hive.dart';

part 'reminder.g.dart';

@HiveType(typeId: 4)
class Reminder extends HiveObject {
  @HiveField(0)
  DateTime? clockBegin;
  @HiveField(1)
  bool remindMe = false;
}
