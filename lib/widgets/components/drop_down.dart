import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DropDownCustom extends StatefulWidget {
  const DropDownCustom({Key? key, required this.widget, required this.size}) : super(key: key);
  final Widget widget;
  final Size size;
  @override
  _DropDownCustomState createState() => _DropDownCustomState();
}

class _DropDownCustomState extends State<DropDownCustom> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 6,
          child: ConstrainedBox(
            constraints: isExpanded
                  ? new BoxConstraints()
                  : new BoxConstraints(maxHeight: widget.size.longestSide / 5),
              child: widget.widget),
        ),
        Expanded(flex: 1,
          child: IconButton(
            onPressed: () => setState(() => isExpanded = !isExpanded),
            icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
          ),
        ),
      ],
    );
  }
}
