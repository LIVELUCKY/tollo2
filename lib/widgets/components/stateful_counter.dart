import 'package:flutter/widgets.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:tollo2/models/job.dart';
import 'package:tollo2/services/formatters/duration_formatter_in_days.dart';

class StatefulCounter extends StatelessWidget {
  const StatefulCounter({Key? key, required this.job, required this.scale}) : super(key: key);
  final Job job;
  final double scale;


  @override
  Widget build(BuildContext context) {
    if (job.register == null) return Text('00:00:00');
    if (job.register!.stateOn) {
      return TimerBuilder.periodic(Duration(seconds: 1), //updates every second
          builder: (context) {
        return Text(durationFormatter(job.getElapsedAll()),textScaleFactor:scale ,);
      });
    } else {
      return Text(durationFormatter(job.getElapsedAll()),textScaleFactor:scale ,);
    }
  }
}
