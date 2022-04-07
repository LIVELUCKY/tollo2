import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomCard extends StatelessWidget {
  const CustomCard(
      {Key? key, required this.widget,  required this.size})
      : super(key: key);
  final Widget widget;

  final Size size;

  @override
  Widget build(BuildContext context) {

    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
          side: BorderSide(
            width: size.aspectRatio * 5,
            color: Theme.of(context).cardColor
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: widget,
        ));
  }
}
