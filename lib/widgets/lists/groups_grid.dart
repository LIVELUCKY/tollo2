import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tollo2/models/group.dart';
import 'package:tollo2/providers/groups_model.dart';
import 'package:tollo2/widgets/lists/groups_tile.dart';

class GroupsGrid extends StatefulWidget {
  const GroupsGrid({Key? key}) : super(key: key);

  @override
  _GroupsGridState createState() => _GroupsGridState();
}

class _GroupsGridState extends State<GroupsGrid> {
  late List<Groups> groups;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    groups = Provider.of<GroupModel>(context).categories;
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: groups.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        Groups group = groups[index];
        return GroupsTile(group: group, size: size);
      },
    );
  }
}
