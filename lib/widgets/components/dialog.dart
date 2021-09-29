import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({Key? key, required this.question}) : super(key: key);
  final String question;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      title: Text(question),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context, false),
          // passing false
          child: Text('No'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          // passing true
          child: Text('Yes'),
        ),
      ],
    );
  }
}
