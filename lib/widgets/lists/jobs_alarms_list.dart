import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:tollo2/models/job.dart';
import 'package:tollo2/providers/job_model.dart';
import 'package:tollo2/services/formatters/duration_formatter_in_days.dart';
import 'package:tollo2/services/sort_by_searched.dart';
import 'package:tollo2/widgets/components/CustomCard.dart';
import 'package:tollo2/widgets/components/drop_down.dart';
import 'package:tollo2/widgets/views/viewJob.dart';

class JobsAlarmsList extends StatefulWidget {
  const JobsAlarmsList({Key? key}) : super(key: key);

  @override
  _JobsAlarmsListState createState() => _JobsAlarmsListState();
}

class _JobsAlarmsListState extends State<JobsAlarmsList> {
  String searched = '';
  late List<Job> jobs;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    jobs = Provider.of<JobModel>(context)
        .jobs
        .where((element) => ((element.deadLine != null &&
                element.deadLine!.remindMe &&
                element.deadLine!.clockBegin!.isAfter(DateTime.now())) ||
            element.reminder.isNotEmpty))
        .toList();
    if (jobs != []) jobs = sortJobsByAlarm(jobs);
    return ListView.builder(
      itemCount: jobs.length + 1,
      itemBuilder: (context, index) {
        if (index == 0)
          return Card(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          searched = value;
                        },
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: 'Search In Your Dairy',
                          // border: InputBorder.none,
                          // focusedBorder: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        Job job = jobs[index - 1];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewJob(job: job),
              ),
            );
          },
          child: CustomCard(
              widget: DropDownCustom(
                  widget: Row(
                    children: [
                      Flexible(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: TimerBuilder.periodic(
                              Duration(seconds: 1),
                              builder: (context) {
                                Duration count =
                                    getNearstReminder(job, DateTime.now())
                                        .clockBegin!
                                        .difference(DateTime.now());
                                return Text(durationFormatter(
                                    count.isNegative ? Duration.zero : count));
                              },
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 7,
                        child: Text(
                          job.note!.note,
                          softWrap: true,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                  size: size / 4),
              color: Theme.of(context).cardColor,
              size: size),
        );
      },
    );
  }
}
