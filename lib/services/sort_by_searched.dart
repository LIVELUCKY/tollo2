import 'package:tollo2/models/job.dart';
import 'package:tollo2/models/note.dart';
import 'package:tollo2/models/reminder.dart';

List<Job> sortJobsByString(List<Job> jobs, String searched) {
  jobs.sort((a, b) {
    bool xb = pror(b, searched);
    bool xa = pror(a, searched);
    if (xa && xb) {
      return 0;
    }
    if (xb) return 1;
    return -1;
  });
  return jobs;
}

List<Note> sortNoteByString(List<Note> notes, String searched) {
  notes.sort((a, b) {
    bool xb = (b.note.toLowerCase()).contains(searched.toLowerCase());
    bool xa = (a.note.toLowerCase()).contains(searched.toLowerCase());
    if (xa && xb) {
      return 0;
    }
    if (xb) return 1;
    return -1;
  });
  return notes;
}

bool pror(Job b, String searched) {
  bool xb = (b.note == null)
      ? false
      : ((b.note!.note.toLowerCase()).contains(searched.toLowerCase()) &&
          !b.done);
  return xb;
}

List<Job> sortJobsByAlarm(List<Job> jobs) {
  DateTime now = DateTime.now();
  jobs.sort((a, b) {
    if (a.reminder.isNotEmpty || a.deadLine != null) return -1;
    if (b.reminder.isNotEmpty || b.deadLine != null) return 1;
    Reminder xan = getNearstReminder(a, now);
    Reminder xbn = getNearstReminder(b, now);
    if (xan.clockBegin == xbn.clockBegin) {
      return 0;
    }
    if (xbn.clockBegin!.isBefore(xan.clockBegin!)) return 1;
    return -1;
  });
  return jobs;
}

Reminder getNearstReminder(Job job, DateTime now) {
  final List<Reminder> xa = [];
  job.reminder.forEach((element) {xa.add(element);});
  if (job.deadLine != null) xa.add(job.deadLine!);
  Reminder xan = getNearstOne(xa, now);
  return xan;
}

Reminder getNearstOne(List<Reminder> xb, DateTime now) {
  Reminder xbn = xb.reduce((Reminder x, Reminder y) =>
      x.clockBegin!.difference(now).abs() < y.clockBegin!.difference(now).abs()
          ? x
          : y);
  return xbn;
}
