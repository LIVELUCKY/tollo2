import 'package:date_format/date_format.dart';

String formatDays(DateTime date) {
  return formatDate(date, [D, '   ', HH, ' : ', nn, ' : ', ss, '   ']);
}
