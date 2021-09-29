import 'package:duration_picker_dialog_box/duration_picker_dialog_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DurationPickerCustom extends StatelessWidget {
  const DurationPickerCustom(
      {Key? key,
      required this.callback,
      required this.color,
      required this.size})
      : super(key: key);
  final void Function(Duration) callback;
  final Color color;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: color,
        ),
        onPressed: () async {
          showDialog(
            context: context,
            builder: (context) {
              Duration duration = Duration();
              return AlertDialog(
                scrollable: true,
                content: SizedBox(
                    width: size.shortestSide,
                    height: size.longestSide * 0.6,
                    child: DurationPicker(
                      duration: duration,
                      onChange: (value) {
                        duration = value;
                      },
                      durationPickerMode: DurationPickerMode.Day,
                    )),
                actions: [
                  ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('cancel')),
                  ElevatedButton(
                      onPressed: () => Navigator.pop(context, duration),
                      child: Text('confirm')),
                ],
              );
            },
          ).then((value) {
            callback(value);
          });
        },
        child: Icon(CupertinoIcons.alarm_fill),
      ),
    );
  }
}
