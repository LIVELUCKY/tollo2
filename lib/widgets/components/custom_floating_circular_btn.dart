import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomFloatingCircularButton extends StatelessWidget {
  const CustomFloatingCircularButton(
      {Key? key,
      required,
      required this.onPressed,
      required this.iconData,
      required this.widthAndHeight})
      : super(key: key);

  final VoidCallback onPressed;
  final IconData iconData;
  final double widthAndHeight;

  @override
  Widget build(BuildContext context) {
    Color c = Theme.of(context).buttonColor;
    return FloatingActionButton(
      elevation: 4.0,
      onPressed: onPressed,
      child: Container(
        height: widthAndHeight,
        width: widthAndHeight,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              c.withAlpha(80),
              c.withAlpha(10),
              c,
            ],
          ),
        ),
        child: Icon(
          iconData,
          color: Colors.white,
        ),
      ),
    );
  }
}
