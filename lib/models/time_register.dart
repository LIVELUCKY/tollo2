import 'package:hive/hive.dart';

import 'track_unit.dart';

part 'time_register.g.dart';

@HiveType(typeId: 6)
class TimeRegister extends HiveObject {
  @HiveField(0)
  bool stateOn = false;
  @HiveField(1)
  List<TimeTrackUnit> register = [];

  Duration getElapsedOfLastOnTillNow() {
    if (register.length == 0 ||
        register.where((element) => element.end == null).length == 0)
      return Duration.zero;
    return DateTime.now().difference(getNotEnded().begin);
  }

  Duration getElapsedAllInRegister() {
    return register.fold(getElapsedOfLastOnTillNow(),
        (previousValue, element) => previousValue + element.duration());
  }

  TimeTrackUnit getNotEnded() {
    return register.firstWhere((element) => element.end == null);
  }
}
