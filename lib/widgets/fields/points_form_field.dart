import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class PointsFormField extends StatelessWidget {
  const PointsFormField({Key? key, required this.controllerPoints}) : super(key: key);
  final TextEditingController controllerPoints;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controllerPoints,
      keyboardType: TextInputType.numberWithOptions(
          decimal: false, signed: false),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],      validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please Enter Points';
      }
      return null;
    },
      decoration: InputDecoration(
          labelText: 'Enter Job Points',
          border: InputBorder.none,
          focusedBorder: UnderlineInputBorder(),
          prefixText: '+'),
      textAlign: TextAlign.center,textInputAction: TextInputAction.next,
    );
  }
}
