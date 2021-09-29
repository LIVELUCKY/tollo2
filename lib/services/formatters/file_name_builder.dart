import 'package:tollo2/services/formatters/date_full.dart';

String buildParsePath(String audioPath) {
  return formatFull(
    DateTime.parse(
        audioPath.substring(0, audioPath.length - 4).split('/').last),
  );
}
