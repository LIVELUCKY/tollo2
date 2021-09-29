import 'package:tollo2/models/job.dart';

List<Job> deleteOldAlarms(List<Job> jobs) {
  DateTime now = DateTime.now();
  for (Job job in jobs) {
    if (job.deadLine != null) {
      if (job.deadLine!.clockBegin!.isBefore(now) && job.deadLine!.remindMe) {
        job.deadLine!.remindMe = false;
      }
    }
    job.reminder = job.reminder
        .where((element) => element.clockBegin!.isAfter(now))
        .toList();
    job.save();
  }
  return jobs;
}
