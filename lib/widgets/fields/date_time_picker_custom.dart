import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class DateTimePickerCustom extends StatelessWidget {
  const DateTimePickerCustom(
      {Key? key, required this.callback, required this.color})
      : super(key: key);
  final void Function(DateTime) callback;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: color,
        ),
        onPressed: () {
          DateTime now = DateTime.now();
          DatePicker.showDateTimePicker(context,
              showTitleActions: true,
              minTime: now,
              maxTime: now.add(
                Duration(days: 30 * 6),
              ), onConfirm: (date) {
            callback(date);
          }, currentTime: now, locale: LocaleType.en);
        },
        child: Icon(CupertinoIcons.calendar_badge_plus),
      ),
    );
  }
}
