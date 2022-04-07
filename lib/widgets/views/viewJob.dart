import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:tollo2/models/job.dart';
import 'package:tollo2/models/note.dart';
import 'package:tollo2/models/track_unit.dart';
import 'package:tollo2/providers/groups_model.dart';
import 'package:tollo2/providers/job_model.dart';
import 'package:tollo2/services/formatters/date_full.dart';
import 'package:tollo2/services/formatters/duration_formatter_in_days.dart';
import 'package:tollo2/services/notification.dart';
import 'package:tollo2/services/permissions/storage_perm.dart';
import 'package:tollo2/widgets/components/CustomCard.dart';
import 'package:tollo2/widgets/components/audio_player.dart';
import 'package:tollo2/widgets/components/bread_crumbs.dart';
import 'package:tollo2/widgets/components/dialog.dart';
import 'package:tollo2/widgets/components/drop_down.dart';
import 'package:tollo2/widgets/components/stateful_counter.dart';
import 'package:tollo2/widgets/forms/newJob.dart';
import 'package:tollo2/widgets/lists/jobs_list.dart';
import 'package:tollo2/widgets/lists/register_list.dart';
import 'package:tollo2/widgets/lists/reminders_list.dart';
import 'package:tollo2/widgets/views/gallery.dart';

class ViewJob extends StatefulWidget {
  const ViewJob({Key? key, required this.job}) : super(key: key);
  final Job job;

  @override
  _ViewJobState createState() => _ViewJobState();
}

class _ViewJobState extends State<ViewJob> {
  bool isExpanded = false;
  List<Job> fathers = [];
  final picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Job flag;
    if (widget.job.father != null) {
      flag = widget.job.father!;
      fathers.add(flag);
    }
  }

  @override
  Widget build(BuildContext context) {
    Color color = Color(widget.job.categoryColor);
    Size size = MediaQuery.of(context).size;
    List<Job> jobs = [];
    if (widget.job.children != null) jobs = widget.job.children!.toList();
    var indent2 = size.shortestSide / 8;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: size.longestSide / 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(CupertinoIcons.back),
                    ),
                    IconButton(
                      onPressed: () async {
                        bool edited = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => new NewJob(
                              edit: true,
                              job: widget.job,
                            ),
                          ),
                        );
                        if (edited) {
                          setState(() {});
                        }
                      },
                      icon: Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () async {
                        bool canDeleteFiles = await checkPermissionsStorage();
                        if (canDeleteFiles) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CustomDialog(
                                  question:
                                      'Are you sure You want to delete this Job');
                            },
                          ).then((exit) async {
                            if (exit == null) return;

                            if (exit) {
                              // user pressed Yes button
                              Provider.of<JobModel>(context, listen: false)
                                  .deleteJob(widget.job);
                              Provider.of<GroupModel>(context, listen: false)
                                  .deleteJobFromGroup(widget.job);
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
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RemindersList(
                                    job: widget.job,
                                    callback: () {
                                      setState(() {});
                                    },
                                  )),
                        );
                      },
                      icon: Icon(CupertinoIcons.alarm),
                    ),
                    IconButton(
                      onPressed: () {
                        if (widget.job.done) return;
                        if (widget.job.children!
                                .where((element) => element.done == false)
                                .toList()
                                .length !=
                            0) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                title: Text(
                                    'Can\'t close Tollo (Sub Tollos are Not Done yet) '),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    // passing true
                                    child: Text('Ok'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CustomDialog(
                                  question:
                                      'Are you sure You want to delete this Tollo');
                            },
                          ).then((exit) {
                            if (exit == null) return;
                            if (exit) {
                              widget.job.done = true;

                              Provider.of<JobModel>(context, listen: false)
                                  .updateJob(widget.job);
                              setState(() {});
                            }
                          });
                        }
                      },
                      icon: Icon(
                        widget.job.done
                            ? CupertinoIcons.checkmark_rectangle
                            : CupertinoIcons.square,
                        size: size.shortestSide / 20,
                      ),
                    )
                  ],
                ),
              ),
              if (widget.job.doneAt != null && widget.job.done)
                CustomCard(
                    widget: Center(
                      child: Text(
                        "Done At : " + formatFull(widget.job.doneAt!),
                      ),
                    ),
                    size: size),
              if (fathers.length != 0) BreadCrumbs(jobs: fathers, size: size),
              CustomCard(
                  widget: Center(
                    child: Text(
                      "Created At : " + formatFull(widget.job.note!.createdAt),
                    ),
                  ),
                  size: size),
              buildDivider(color, size, indent2),
              if (widget.job.deadLine != null)
                CustomCard(
                    widget: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Deadline : ${formatFull(widget.job.deadLine!.clockBegin!)}',
                          ),
                          Switch(
                            value: widget.job.deadLine!.remindMe,
                            onChanged: (value) async {
                              widget.job.deadLine!.remindMe =
                                  !widget.job.deadLine!.remindMe;
                              Provider.of<JobModel>(context, listen: false)
                                  .updateJob(widget.job);
                              setState(() {});
                              if (widget.job.deadLine!.remindMe) {
                                await registerNotification(
                                    widget.job, widget.job.deadLine!);
                              } else {
                                await deleteNotification(widget.job.deadLine!);
                              }
                            },
                          )
                        ],
                      ),
                    ),
                    size: size),
              buildDivider(color, size, indent2),
              CustomCard(
                  widget: DropDownCustom(
                    size: size,
                    widget: new Text(
                      widget.job.note!.note,
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                  size: size),
              buildDivider(color, size, indent2),
              if (widget.job.register != null)
                CustomCard(
                    widget: Center(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: (widget.job.register != null)
                                ? [
                                    Flexible(
                                      flex: 1,
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  RegisterNotesList(
                                                      job: widget.job),
                                            ),
                                          );
                                        },
                                        icon: Icon(
                                          CupertinoIcons
                                              .list_bullet_below_rectangle,
                                          size: size.shortestSide / 20,
                                        ),
                                      ),
                                    ),
                                    if (widget.job.register!.stateOn)
                                      Flexible(
                                        flex: 2,
                                        child: TimerBuilder.periodic(
                                            Duration(
                                                seconds:
                                                    1), //updates every second
                                            builder: (context) {
                                          return Text(
                                            durationFormatter(
                                              widget.job.register!
                                                  .getElapsedOfLastOnTillNow(),
                                            ),
                                          );
                                        }),
                                      ),
                                    if (!widget.job.register!.stateOn)
                                      Flexible(
                                        flex: 1,
                                        child: IconButton(
                                          onPressed: () {
                                            widget.job.register!.stateOn =
                                                !widget.job.register!.stateOn;
                                            widget.job.register!.register.add(
                                              new TimeTrackUnit(),
                                            );
                                            Provider.of<JobModel>(context,
                                                    listen: false)
                                                .updateJob(widget.job);
                                            setState(() {});
                                          },
                                          icon: Icon(
                                            CupertinoIcons.timer,
                                            size: size.shortestSide / 20,
                                            color: widget.job.register!.stateOn
                                                ? Colors.green
                                                : Colors.grey,
                                          ),
                                        ),
                                      ),
                                    if (widget.job.register!.stateOn)
                                      Flexible(
                                        flex: 4,
                                        child: TextField(
                                          minLines: 1,
                                          maxLines: null,
                                          decoration: InputDecoration(
                                            hintText: 'What did you do?',
                                            border: InputBorder.none,
                                            focusedBorder:
                                                UnderlineInputBorder(),
                                          ),
                                          textInputAction: TextInputAction.done,
                                          onChanged: (value) {
                                            if (widget.job.register!
                                                    .getNotEnded()
                                                    .note ==
                                                null) {
                                              widget.job.register!
                                                  .getNotEnded()
                                                  .note = Note();
                                            }
                                            widget.job.register!
                                                .getNotEnded()
                                                .note!
                                                .note = value;
                                            Provider.of<JobModel>(context,
                                                    listen: false)
                                                .updateJob(widget.job);
                                          },
                                          onSubmitted: (value) {
                                            if (widget.job.register!
                                                    .getNotEnded()
                                                    .note ==
                                                null) {
                                              widget.job.register!
                                                  .getNotEnded()
                                                  .note = Note();
                                            }
                                            widget.job.register!
                                                .getNotEnded()
                                                .note!
                                                .note = value;
                                            widget.job.register!
                                                .getNotEnded()
                                                .end = DateTime.now();
                                            widget.job.register!.stateOn =
                                                !widget.job.register!.stateOn;
                                            Provider.of<JobModel>(context,
                                                    listen: false)
                                                .updateJob(widget.job);
                                            setState(() {});
                                          },
                                        ),
                                      )
                                  ]
                                : [],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('Time invested :'),
                              StatefulCounter(
                                job: widget.job,
                                scale: 1.0,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    size: size),
              buildDivider(color, size, indent2),
              CustomCard(
                  widget: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    JobGallery(job: widget.job),
                              ),
                            );
                          },
                          icon: Icon(Icons.photo_album)),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AudioPlayerWidget(
                                  job: widget.job,
                                ),
                              ),
                            );
                          },
                          icon: Icon(CupertinoIcons.music_albums)),
                    ],
                  ),
                  size: size),
              buildDivider(color, size, indent2),
              CustomCard(
                  widget: Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewJob(
                                job: widget.job,
                                edit: false,
                              ),
                            ),
                          );
                        },
                        icon: Icon(CupertinoIcons.add),
                      ),
                      DropDownCustom(
                          widget: SizedBox(
                            width: size.shortestSide / 4,
                            height: size.longestSide,
                            child: HomeList(
                              job: widget.job,
                            ),
                          ),
                          size: size * 0.6),
                    ],
                  ),
                  size: size),
            ],
          ),
        ),
      ),
    );
  }

  Divider buildDivider(Color color, Size size, double indent2) {
    return Divider(
              color: color,
              thickness: size.aspectRatio * 4,
              indent: indent2,
              endIndent: indent2,
            );
  }
}
