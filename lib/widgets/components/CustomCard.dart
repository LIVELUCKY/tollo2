import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomCard extends StatelessWidget {
  const CustomCard(
      {Key? key, required this.widget, required this.color, required this.size})
      : super(key: key);
  final Widget widget;
  final Color color;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
          side: BorderSide(
            color: color,
            width: size.aspectRatio * 5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: widget,
        ));
  }
}
