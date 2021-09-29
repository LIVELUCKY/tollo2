import 'package:date_format/date_format.dart';

String formatFull(DateTime date) {
  return formatDate(date, [
    yy,
    ' / ',
    mm,
    ' / ',
    dd,
    ' ',
    D,
    '   ',
    HH,
    ' : ',
    nn,
    ' : ',
    ss,
    '   '
  ]);
}
