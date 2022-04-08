import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tollo2/models/group.dart';
import 'package:tollo2/services/formatters/date_full.dart';
import 'package:tollo2/widgets/views/viewGroup.dart';

import '../../services/textDirection.dart';

class GroupsTile extends StatelessWidget {
  const GroupsTile({Key? key, required this.group, required this.size})
      : super(key: key);
  final Groups group;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ViewGroup(
                    group: group,
                  )),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(
            color: Color(group.categoryColor),
            width: size.aspectRatio * 5,
          ),
        ),
        child: Column(

          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: Text(
                      formatFull(group.note!.createdAt),
                      style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodyText1!.fontSize! *
                                  0.8),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                        height: size.aspectRatio * 40,
                        child: VerticalDivider(
                          thickness: size.aspectRatio * 4,
                          color: Color(group.categoryColor),
                        )),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      group.jobs!.length.toString(),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Color(group.categoryColor),
              thickness: size.aspectRatio * 4,
            ),
            Text(
              group.note!.note,
              softWrap: true,
              overflow: TextOverflow.fade,
              textScaleFactor: size.aspectRatio * 1.6,
              textAlign:   isRTL(group.note!.note)?TextAlign.right:TextAlign.left
            ),
          ],
        ),
      ),
    );
  }
}
