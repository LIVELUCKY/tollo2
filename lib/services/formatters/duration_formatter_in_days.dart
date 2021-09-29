import 'package:flutter/material.dart';

// Text durationFormatterInDays(Job job) {
//   Duration d = job.getElapsedAll();
//   return Text(
//       '${d.inDays}:${d.inHours.remainder(24)}:${d.inMinutes.remainder(60)}');
// }

String durationFormatter(Duration duration) {
  return
      '${duration.inDays}:${duration.inHours.remainder(24)}:${duration.inMinutes.remainder(60)}:${duration.inSeconds.remainder(60)}';
}
