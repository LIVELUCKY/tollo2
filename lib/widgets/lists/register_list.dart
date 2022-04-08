import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:tollo2/models/job.dart';
import 'package:tollo2/models/track_unit.dart';
import 'package:tollo2/widgets/components/CustomCard.dart';
import 'package:tollo2/widgets/components/stateful_counter.dart';

import '../../services/formatters/date_full.dart';
import '../../services/formatters/duration_formatter_in_days.dart';
import '../../services/textDirection.dart';

class RegisterNotesList extends StatefulWidget {
  const RegisterNotesList({Key? key, required this.job}) : super(key: key);
  final Job job;

  @override
  _RegisterNotesListState createState() => _RegisterNotesListState();
}

class _RegisterNotesListState extends State<RegisterNotesList> {
  final bool animate = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var indent2 = size.shortestSide / 10;
    List<TimeTrackUnit> register =
        widget.job.getAllTimeUnits().reversed.toList();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildConstrainedBoxForBack(size, context),
            totalCounter(size),
            SizedBox(
              height: size.longestSide * 0.76,
              child: ListView.builder(
                itemCount: register.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  TimeTrackUnit ttu = register[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        (ttu.note != null)
                            ? Text(
                                ttu.note!.note,
                          textAlign: isRTL(ttu.note!.note)
                              ? TextAlign.right
                              : TextAlign.left,
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold),
                              )
                            : Text('Not Closed yet',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: (Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .fontSize)! *
                                        1.2)),
                        Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                flex: 2,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    formatFull(ttu.begin),
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                    ),
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
                        ),
                        Divider(
                            thickness: size.aspectRatio * 4,
                            color: Color(widget.job.categoryColor),
                            indent: indent2,
                            endIndent: indent2),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row totalCounter(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CustomCard(
            widget: StatefulCounter(
              job: widget.job,
              scale: size.aspectRatio * 10,
            ),
            size: size),
      ],
    );
  }

  ConstrainedBox buildConstrainedBoxForBack(Size size, BuildContext context) {
    return ConstrainedBox(
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
    );
  }
}

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  late final Duration sales;

  TimeSeriesSales(this.time, this.sales);
}
