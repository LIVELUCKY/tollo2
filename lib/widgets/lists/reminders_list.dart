import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tollo2/models/job.dart';
import 'package:tollo2/models/reminder.dart';
import 'package:tollo2/providers/job_model.dart';
import 'package:tollo2/services/formatters/date_full.dart';
import 'package:tollo2/services/notification.dart';
import 'package:tollo2/widgets/components/CustomCard.dart';
import 'package:tollo2/widgets/fields/date_time_picker_custom.dart';

class RemindersList extends StatefulWidget {
  const RemindersList({Key? key, required this.job, required this.callback})
      : super(key: key);
  final Job job;
  final Function() callback;

  @override
  _RemindersListState createState() => _RemindersListState();
}

class _RemindersListState extends State<RemindersList> {
  late List<Reminder> reminders;
  late Color color;

  void setDeadLine(DateTime dateTime) {
    Reminder reminder = Reminder();
    reminder.clockBegin = dateTime;
    widget.job.reminder.add(reminder);
    Provider.of<JobModel>(context, listen: false).updateJob(widget.job);
    setState(() {});
    widget.callback();
  }

  @override
  Widget build(BuildContext context) {
    color = Color(widget.job.categoryColor);
    reminders = widget.job.reminder;
    reminders.sort((a, b) => a.clockBegin!.compareTo(b.clockBegin!));
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: reminders.length + 1,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            if (index == 0)
              return DateTimePickerCustom(callback: setDeadLine, color: color);
            Reminder reminder = reminders[index - 1];
            return CustomCard(
                widget: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(formatFull(reminder.clockBegin!)),
                    Switch(
                      value: reminder.remindMe,
                      onChanged: (value) async {
                        reminder.remindMe = value;
                        Provider.of<JobModel>(context, listen: false)
                            .updateJob(widget.job);
                        setState(() {});
                        if (reminder.remindMe) {
                          await registerNotification(widget.job, reminder);
                        } else {
                          await deleteNotification(reminder);
                        }
                      },
                    ),
                    IconButton(
                        onPressed: () {
                          reminders.remove(reminder);
                          Provider.of<JobModel>(context, listen: false)
                              .updateJob(widget.job);
                          setState(() {});
                        },
                        icon: Icon(
                          CupertinoIcons.trash,
                          color: Colors.red.shade500,
                        ))
                  ],
                ),

                size: size);
          },
        ),
      ),
    );
  }
}
