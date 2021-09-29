import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:tollo2/models/job.dart';
import 'package:tollo2/models/track_unit.dart';
import 'package:tollo2/services/formatters/date_full.dart';
import 'package:tollo2/services/formatters/duration_formatter_in_days.dart';
import 'package:tollo2/widgets/components/CustomCard.dart';
import 'package:tollo2/widgets/components/stateful_counter.dart';

class RegisterNotesList extends StatefulWidget {
  const RegisterNotesList({Key? key, required this.job}) : super(key: key);
  final Job job;

  @override
  _RegisterNotesListState createState() => _RegisterNotesListState();
}

class _RegisterNotesListState extends State<RegisterNotesList> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<TimeTrackUnit> register =
        widget.job.getAllTimeUnits().reversed.toList();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: size.longestSide / 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(CupertinoIcons.back),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomCard(
                    widget: StatefulCounter(
                      job: widget.job,
                      scale: size.aspectRatio * 10,
                    ),
                    color: Color(widget.job.categoryColor),
                    size: size),
              ],
            ),
            CustomCard(
                widget: Column(
                  children: [
                    SizedBox(
                      height: size.longestSide / 2,
                      child: ListView.builder(
                        itemCount: register.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          TimeTrackUnit ttu = register[index];
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        formatFull(ttu.begin),
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: TimerBuilder.periodic(
                                          Duration(seconds: 1),
                                          //updates every second
                                          builder: (context) {
                                        return Text(
                                          durationFormatter(
                                            ttu.duration(),
                                          ),
                                        );
                                      }),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: (ttu.note != null)
                                          ? Text(
                                              ttu.note!.note,
                                              textAlign: TextAlign.left,
                                            )
                                          : Text('Not Closed yet'),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
                color: Color(widget.job.categoryColor),
                size: size),
          ],
        ),
      ),
    );
  }
}
