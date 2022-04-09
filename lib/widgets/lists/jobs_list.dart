import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tollo2/models/group.dart';
import 'package:tollo2/models/job.dart';
import 'package:tollo2/providers/groups_model.dart';
import 'package:tollo2/providers/job_model.dart';
import 'package:tollo2/services/sort_by_searched.dart';
import 'package:tollo2/widgets/lists/job_list_tile.dart';

import '../../services/textDirection.dart';

class HomeList extends StatefulWidget {
  const HomeList({Key? key, this.job, this.size, this.category, this.widget})
      : super(key: key);
  final Job? job;
  final Size? size;
  final Groups? category;
  final Widget? widget;

  @override
  _HomeListState createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
  String searched = '';
  bool children = true;
  late List<Job> jobs;
  bool r = false;

  @override
  Widget build(BuildContext context) {
    Size size =
        widget.size == null ? MediaQuery.of(context).size : widget.size!;
    var jobModel = Provider.of<JobModel>(context);
    if (widget.job == null && widget.category == null) {
      if (children) {
        jobs = jobModel.jobs
            .where((element) =>
                element.father == null &&
                !Provider.of<GroupModel>(context).containedInAGroup(element))
            .toList();
      } else {
        jobs = jobModel.jobs;
      }
    } else {
      if (widget.category != null && widget.job == null) {
        jobs = widget.category!.jobs!;
      } else {

        jobs =jobModel.getJobChilds(widget.job!);
      }
    }
    jobs = sortJobsByString(jobs, searched);
    return ListView.builder(
      shrinkWrap: true,
      itemCount: jobs.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) return searchField();

        return HomeJobListTile(
          searched: searched,
          job: jobs[index - 1],
          size: size,
        );
      },
    );
  }

  Card searchField() {
    return Card(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 7,
                child: TextField(
                  onChanged: (value) {
                    searched = value;
                    setState(() {
                      r = isRTL(value);
                    });
                  },
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                    setState(() {});
                  },
                  textAlign: r ? TextAlign.right : TextAlign.left,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                    hintText: 'Search Jobs...',
                    // border: InputBorder.none,
                    // focusedBorder: UnderlineInputBorder(),
                  ),
                ),
              ),
              Expanded(flex: 1, child: jobsTreeSwitcher())
            ],
          ),
          if (widget.widget != null) widget.widget!
        ],
      ),
    );
  }

  IconButton jobsTreeSwitcher() {
    return IconButton(
        onPressed: () {
          children = !children;
          setState(() {});
        },
        icon: Icon(children
            ? Icons.account_tree_outlined
            : Icons.account_tree_rounded));
  }

  bool topFather(Job element) => element.father == null;

  bool notTopFather(Job element) => true;
}
