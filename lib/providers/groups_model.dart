import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:tollo2/models/group.dart';
import 'package:tollo2/models/job.dart';

class GroupModel extends ChangeNotifier {
  List<Groups> categories = [];
  var groupsBox = Hive.box<Groups>('groups');
  var jobBox = Hive.box<Job>('jobs');

  GroupModel() {
    categories = groupsBox.values.toList();
    notifyListeners();
  }

  addGroup(Groups groups) async {
    await groupsBox.add(groups);
    updateGroups();
  }

  deleteGroup(Groups groups) async {
    await groupsBox.delete(groups.key);
    updateGroups();
  }

  updateGroups() {
    categories = groupsBox.values.toList();
    notifyListeners();
  }

  addJobToGroup(Groups groups, Job job) async {
    job.children = HiveList(jobBox);
    await jobBox.add(job);
    groups.jobs!.add(job);
    groups.save();
    notifyListeners();
  }

  deleteJobFromGroup(Job job) {
    if (containedInAGroup(job)) {
      Groups group =
          categories.firstWhere((group) => group.jobs!.contains(job));
      group.jobs!.remove(job);
      group.save();
      notifyListeners();
    }
  }

  Groups getGroupOfJob(Job job) {
    return categories.firstWhere((group) => group.jobs!.contains(job));
  }

  containedInAGroup(Job job) {
    return categories.expand((element) => element.jobs!).contains(job);
  }
}
