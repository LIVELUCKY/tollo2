import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DescriptionFormField extends StatelessWidget {
  const DescriptionFormField({Key? key, required this.controllerDescription}) : super(key: key);
  final TextEditingController controllerDescription;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controllerDescription,
      minLines: 2,
      maxLines: null,
      autofocus: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please Enter a Description';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: 'Enter a Job Description',
        border: InputBorder.none,
        focusedBorder: UnderlineInputBorder(),
      ),
      textInputAction: TextInputAction.next,
    );
  }
}
