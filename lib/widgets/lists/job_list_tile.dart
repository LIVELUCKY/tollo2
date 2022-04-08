import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:tollo2/models/job.dart';
import 'package:tollo2/providers/job_model.dart';
import 'package:tollo2/services/formatters/date_full.dart';
import 'package:tollo2/services/formatters/trimmer.dart';
import 'package:tollo2/services/textDirection.dart';
import 'package:tollo2/widgets/components/dialog.dart';
import 'package:tollo2/widgets/components/drop_down.dart';
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
    var text2 = trimTill(job.note!.note, searched);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => new ViewJob(job: job),
          ),
        );
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Created at : ' + formatFull(job.note!.createdAt),
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.bodyText1!.fontSize! *
                              0.8),
                ),
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.color_filter,
                      color: jobColor,
                    ),
                    isRegisterOn(),
                    if (job.father != null)
                      Icon(
                        Icons.account_tree_rounded,
                        color: Color(job.father!.categoryColor),
                      )
                  ],
                )
              ],
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropDownCustom(
                widget: SubstringHighlight(
                  text: text2,textAlign:isRTL(text2)?TextAlign.right:TextAlign.left ,
                  term: searched,
                  overflow: TextOverflow.fade,
                  textStyle: Theme.of(context).textTheme.bodyText1!,
                  textStyleHighlight: TextStyle(
                      backgroundColor: Theme.of(context).primaryColorLight),
                ),
                size: size,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void deleteTollo(BuildContext context) {
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

  Widget isRegisterOn() {
    return Icon(
      CupertinoIcons.alarm_fill,
      size: size.shortestSide / 20,
      color: job.register!.stateOn ? Colors.green : Colors.grey,
    );
  }
}
