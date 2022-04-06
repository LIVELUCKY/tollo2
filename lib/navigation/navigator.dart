import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tollo2/widgets/components/custom_floating_circular_btn.dart';
import 'package:tollo2/widgets/forms/newGroup.dart';
import 'package:tollo2/widgets/forms/newJob.dart';
import 'package:tollo2/widgets/forms/newNote.dart';
import 'bottom_routes.dart';

class BottomMainNavigator extends StatefulWidget {
  const BottomMainNavigator({Key? key}) : super(key: key);

  @override
  State<BottomMainNavigator> createState() => _BottomMainNavigatorState();
}

class _BottomMainNavigatorState extends State<BottomMainNavigator> {
  PageController _myPage = PageController(initialPage: 0, keepPage: true);
  var selectedPage;

  @override
  void initState() {
    super.initState();
    selectedPage = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _myPage,
        children: routes.values.toList(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: new Visibility(
        visible: selectedPage > 3 ? false : true,
        child: CustomFloatingCircularButton(
          widthAndHeight: 60,
          onPressed: () {
            if (selectedPage == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewJob(
                    edit: false,
                  ),
                ),
              );
            } else if (selectedPage == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewGroup()),
              );
            } else if (selectedPage == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewNote()),
              );
            } else {
              print(selectedPage.toString());
            }
          },
          iconData: CupertinoIcons.add,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 5.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (int i = 0; i < 2; i++) buildIBottomBarButton(i),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                for (int i = 2; i < 4; i++) buildIBottomBarButton(i),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconButton buildIBottomBarButton(int i) {
    return IconButton(
      icon: routes.keys.elementAt(i),
      color: bottomBtnColor(i),
      onPressed: () {
        pageNav(i);
      },
    );
  }

  void pageNav(p) {
    _myPage.jumpToPage(p);
    setState(() {
      selectedPage = p;
    });
  }

  Color bottomBtnColor(val) =>
      selectedPage == val ? Theme.of(context).primaryColor : Colors.grey;
}
