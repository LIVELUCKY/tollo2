import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tollo2/models/group.dart';
import 'package:tollo2/services/formatters/date_full.dart';
import 'package:tollo2/widgets/views/viewGroup.dart';

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
          borderRadius: BorderRadius.circular(25.0),
          side: BorderSide(
            color: Color(group.categoryColor),
            width: size.aspectRatio * 5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(children: [
              Text(
                formatFull(group.note!.createdAt),
                style: TextStyle(
                    fontSize:
                        Theme.of(context).textTheme.bodyText1!.fontSize! * 0.8),
              ),
              Container(
                decoration: BoxDecoration(
                  border:
                      Border.all(width: 2, color: Color(group.categoryColor)),
                  shape: BoxShape.circle,
                  // You can use like this way or like the below line
                  //borderRadius: new BorderRadius.circular(30.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(group.jobs!.length.toString()),
                ),
              ),
            ]),
            Divider(
              color: Color(group.categoryColor),
              thickness: size.aspectRatio * 4,
            ),
            Text(
              group.note!.note,
              softWrap: true,
              overflow: TextOverflow.fade,
              textScaleFactor: size.aspectRatio * 1.6,
            ),
          ],
        ),
      ),
    );
  }
}
