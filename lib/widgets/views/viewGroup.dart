import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tollo2/models/group.dart';
import 'package:tollo2/models/job.dart';
import 'package:tollo2/providers/groups_model.dart';
import 'package:tollo2/providers/job_model.dart';
import 'package:tollo2/services/formatters/date_full.dart';
import 'package:tollo2/services/permissions/storage_perm.dart';
import 'package:tollo2/widgets/components/dialog.dart';
import 'package:tollo2/widgets/forms/newJob.dart';
import 'package:tollo2/widgets/lists/jobs_list.dart';

import '../../services/textDirection.dart';

class ViewGroup extends StatefulWidget {
  const ViewGroup({Key? key, required this.group}) : super(key: key);
  final Groups group;

  @override
  _ViewGroupState createState() => _ViewGroupState();
}

class _ViewGroupState extends State<ViewGroup> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var note2 = widget.group.note!.note;
    return SafeArea(
      child: Scaffold(
        body: HomeList(
          category: widget.group,
          widget: Column(
            crossAxisAlignment: isRTL(note2)
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  formatFull(widget.group.note!.createdAt),
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewJob(
                              edit: false,
                              groups: widget.group,
                            ),
                          ),
                        );
                      },
                      icon: Icon(CupertinoIcons.add)),
                  IconButton(
                      onPressed: () async {
                        bool canDeleteFiles = await checkPermissionsStorage();
                        if (canDeleteFiles) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CustomDialog(
                                  question:
                                      'Are you sure You want to delete this Group and All Jobs In it??');
                            },
                          ).then((exit) async {
                            if (exit == null) return;

                            if (exit) {
                              // user pressed Yes button
                              Provider.of<GroupModel>(context, listen: false)
                                  .deleteGroup(widget.group);
                              for (Job j in widget.group.jobs!) {
                                Provider.of<JobModel>(context, listen: false)
                                    .deleteJob(j);
                              }
                              Navigator.pop(context);
                            } else {
                              // user pressed No button
                            }
                          });
                        }
                      },
                      icon: Icon(
                        CupertinoIcons.trash_fill,
                        color: Colors.red.shade400,
                      ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  note2,
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
