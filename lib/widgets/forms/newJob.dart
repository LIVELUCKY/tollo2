import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tollo2/models/group.dart';
import 'package:tollo2/models/job.dart';
import 'package:tollo2/models/note.dart';
import 'package:tollo2/models/reminder.dart';
import 'package:tollo2/models/time_register.dart';
import 'package:tollo2/providers/groups_model.dart';
import 'package:tollo2/providers/job_model.dart';
import 'package:tollo2/services/textDirection.dart';
import 'package:tollo2/widgets/fields/color_picker_field.dart';
import 'package:tollo2/widgets/fields/date_time_picker_custom.dart';
import 'package:tollo2/widgets/fields/points_form_field.dart';
import 'package:tollo2/widgets/views/viewJob.dart';

class NewJob extends StatefulWidget {
  const NewJob({Key? key, this.job, required this.edit, this.groups})
      : super(key: key);
  final Job? job;
  final bool edit;
  final Groups? groups;

  @override
  _NewJobState createState() => _NewJobState();
}

class _NewJobState extends State<NewJob> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _controllerDescription;
  late TextEditingController _controllerPoints;
  late Color color = Theme.of(context).primaryColor;
  bool jobdesdir=false;
  late Job job;

  @override
  void initState() {
    super.initState();
    if (!widget.edit) {
      job = new Job();
      job.note = new Note();
      job.note!.note = '';
      job.points = 0;
      job.register = new TimeRegister();
    } else {
      job = widget.job!;
      color = Color(job.categoryColor);
    }
    _controllerDescription = new TextEditingController(text: job.note!.note);
    _controllerDescription.addListener(() {setState(() {
      jobdesdir=isRTL(_controllerDescription.text);
    }); });
    _controllerPoints = new TextEditingController(
        text: job.points == 0 ? '' : job.points.toString());
  }

  void setColor(Color c) {
    color = c;
  }

  void setDeadLine(DateTime dateTime) {
    if (job.deadLine == null) job.deadLine = Reminder();
    job.deadLine!.clockBegin = dateTime;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(CupertinoIcons.chevron_down),
                    )
                  ],
                ),
                TextFormField(
                  controller: _controllerDescription,
                  minLines: 2,
                  maxLines: null,
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter a Description';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter a Job Description',
                    border: InputBorder.none,
                    focusedBorder: UnderlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  textAlign: jobdesdir ? TextAlign.right : TextAlign.left,
                ),
                PointsFormField(controllerPoints: _controllerPoints),
                DateTimePickerCustom(callback: setDeadLine, color: color),
                ColorPickerFormField(
                    size: size, color: color, callback: setColor),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: color,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        job.categoryColor = color.value;
                        job.note!.note = _controllerDescription.text;
                        job.points = int.parse(_controllerPoints.text);
                        if (widget.groups == null) {
                          if (!widget.edit) {
                            Provider.of<JobModel>(context, listen: false)
                                .addJob(job);
                            if (widget.job != null) {
                              job.father = widget.job;
                              widget.job!.children!.add(job);
                              Provider.of<JobModel>(context, listen: false)
                                  .updateJob(widget.job!);
                              Provider.of<JobModel>(context, listen: false)
                                  .updateJob(job);
                              Navigator.pop(context);
                            }
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ViewJob(job: job)),
                              ModalRoute.withName('/'),
                            );
                          } else {
                            Provider.of<JobModel>(context, listen: false)
                                .updateJob(job);
                            Navigator.pop(context, true);
                          }
                        } else {
                          Provider.of<GroupModel>(context, listen: false)
                              .addJobToGroup(widget.groups!, job);
                          Provider.of<JobModel>(context, listen: false)
                              .updateJobs();
                          Navigator.pop(context, true);
                        }
                      }
                    },
                    child: Icon(Icons.save),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
