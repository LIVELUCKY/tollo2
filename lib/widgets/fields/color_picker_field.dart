import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';

class ColorPickerFormField extends StatelessWidget {
  const ColorPickerFormField(
      {Key? key,
      required this.size,
      required this.color,
      required this.callback})
      : super(key: key);
  final Size size;
  final Color color;
  final void Function(Color) callback;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: color,
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              Color colorPicked = color;
              return AlertDialog(
                scrollable: true,
                content: SizedBox(
                  width: size.shortestSide,
                  height: size.longestSide * 0.8,
                  child: ColorPicker(
                    onChanged: (value) {
                      colorPicked = value;
                    },
                    initialPicker: Picker.paletteHue,
                  ),
                ),
                actions: [
                  ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('cancel')),
                  ElevatedButton(
                      onPressed: () => Navigator.pop(context, colorPicked),
                      child: Text('confirm')),
                ],
              );
            },
          ).then((value) {
            callback(value);
          });
        },
        child: Icon(CupertinoIcons.color_filter),
      ),
    );
  }
}
