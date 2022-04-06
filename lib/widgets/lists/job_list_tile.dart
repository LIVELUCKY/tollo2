import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:tollo2/models/job.dart';
import 'package:tollo2/providers/groups_model.dart';
import 'package:tollo2/providers/job_model.dart';
import 'package:tollo2/services/formatters/date_full.dart';
import 'package:tollo2/services/formatters/trimmer.dart';
import 'package:tollo2/services/sort_by_searched.dart';
import 'package:tollo2/widgets/components/CustomCard.dart';
import 'package:tollo2/widgets/components/dialog.dart';
import 'package:tollo2/widgets/components/drop_down.dart';
import 'package:tollo2/widgets/components/stateful_counter.dart';
import 'package:tollo2/widgets/lists/groups_tile.dart';
import 'package:tollo2/widgets/views/viewJob.dart';

class HomeJobListTile extends StatelessWidget {
  const HomeJobListTile(
      {Key? key, required this.job, required this.size, required this.searched})
      : super(key: key);
  final Job job;
  final Size size;
  final String searched;

  @override
  Widget build(BuildContext context) {
    Color jobColor = Color(job.categoryColor);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => new ViewJob(job: job),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (Provider.of<GroupModel>(context).containedInAGroup(job))
                        containedInAGroup(context),
                      if (job.father != null) buildFatherRow(context),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // IconButton(
                          //   onPressed: () {
                          //     if (job.done) return;
                          //     if (job.children!
                          //             .where((element) => element.done == false)
                          //             .toList()
                          //             .length !=
                          //         0) {
                          //       showDialog(
                          //         context: context,
                          //         builder: (context) {
                          //           return buildAlertDialogSubTollosNotClosed(context);
                          //         },
                          //       );
                          //     } else {
                          //       DeleteTollo(context);
                          //     }
                          //   },
                          //   icon: Icon(
                          //     job.done
                          //         ? CupertinoIcons.checkmark_rectangle
                          //         : CupertinoIcons.square,
                          //     size: size.shortestSide / 20,
                          //   ),
                          // ),
                          isRegisterOn(),
                        ],
                      ),
                      Divider(),
                      Center(
                          child: StatefulCounter(
                        job: job,
                        scale: 1.0,
                      )),
                      Divider(),
                      Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            children: [
                              Text(job.points.toString(),
                                  textScaleFactor: size.aspectRatio * 2),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 5,
                  child: Column(
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomCard(
                              widget: Row(
                                children: [
                                  Text(
                                    'Created at : ',
                                  ),
                                  Text(
                                    formatFull(job.note!.createdAt),
                                  ),
                                ],
                              ),
                              size: size,
                              color: jobColor,
                            ),
                            Divider(
                              color: jobColor,
                            ),
                            if (job.deadLine != null)
                              CustomCard(
                                widget: Row(
                                  children: [
                                    Text('Dead Line : '),
                                    Text(
                                      formatFull(job.deadLine!.clockBegin!),
                                    ),
                                  ],
                                ),
                                size: size,
                                color: jobColor,
                              ),
                            Divider(),
                            if (job.reminder.isNotEmpty || job.deadLine != null)
                              CustomCard(
                                widget: Row(
                                  children: [
                                    Text('Next Alarm: '),
                                    Text(formatFull(
                                        getNearstReminder(job, DateTime.now())
                                            .clockBegin!)),
                                  ],
                                ),
                                size: size,
                                color: jobColor,
                              ),
                          ],
                        ),
                      ),
                      Divider(),
                      DropDownCustom(
                        widget: SubstringHighlight(
                          text: trimTill(job.note!.note, searched),
                          term: searched,
                          overflow: TextOverflow.fade,
                          textStyle: Theme.of(context).textTheme.bodyText1!,
                          textStyleHighlight: TextStyle(
                              backgroundColor:
                                  Theme.of(context).primaryColorLight),
                        ),
                        size: size,
                      ),
                    ],
                  ),
                ),
                Container(
                  color: jobColor,
                  width: size.shortestSide / 14,
                  height: size.height / 3,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void DeleteTollo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
            question: 'Are you sure You want to delete this Tollo');
      },
    ).then((exit) {
      if (exit == null) return;
      if (exit) {
        job.done = true;
        if (job.points != null)
          Provider.of<JobModel>(context, listen: false).updateJob(job);
      }
    });
  }

  AlertDialog buildAlertDialogSubTollosNotClosed(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      title: Text('Can\'t close Tollo (Sub Tollos are Not Done yet) '),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          // passing true
          child: Text('Ok'),
        ),
      ],
    );
  }

  Row buildFatherRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Father'),
        IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => new ViewJob(job: job.father!),
                ),
              );
            },
            icon: Icon(Icons.account_tree_outlined)),
      ],
    );
  }

  FittedBox containedInAGroup(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: GroupsTile(
          group: Provider.of<GroupModel>(context).getGroupOfJob(job),
          size: size),
    );
  }

  Icon isRegisterOn() {
    return Icon(
      CupertinoIcons.alarm_fill,
      size: size.shortestSide / 10,
      color: job.register!.stateOn ? Colors.green : Colors.grey,
    );
  }
}
