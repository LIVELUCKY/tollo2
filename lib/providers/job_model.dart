import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:tollo2/models/job.dart';
import 'package:tollo2/services/deleteOldAlarms.dart';

class JobModel extends ChangeNotifier {
  List<Job> jobs = [];

  var jobBox = Hive.box<Job>('jobs');

  // var bankBox = Hive.box<Bank>('bank');
  // Bank bank = Bank();

  JobModel() {
    updateJobs();
  }

  updateJobs() async {
    jobs = jobBox.values.toList();
    jobs = deleteOldAlarms(jobs);
    notifyListeners();
  }

  List<Job> getAktive() {
    return jobs.where((element) => element.register!.stateOn).toList();
  }

  Job? getJob(index) {
    return jobBox.get(index);
  }

  Future<void> updateJob(Job job) async {
    job.save();
    updateJobs();
    notifyListeners();
  }

  int get jobsCount {
    return jobs.length;
  }

  addJob(Job job) async {
    job.children = HiveList(jobBox);
    await jobBox.add(job);
    updateJobs();
  }

  deleteJob(Job job) async {
    job.deleteAll();
    await jobBox.delete(job.key);
    updateJobs();
  }

  List<String> getAudiosTotal() {
    return jobs.fold(
        [], (previousValue, element) => previousValue + element.pathsAudios);
  }

  List<String> getImagesTotal() {
    return jobs.fold(
        [], (previousValue, element) => previousValue + element.pathsImages);
  }

  int getTotalRemindersLength() {
    return jobs.fold(
        0,
        (previousValue, element) =>
            previousValue +
            (element.reminder.where((element) => element.remindMe = true))
                .length);
  }
}
