import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tollo2/widgets/components/custom_floating_circular_btn.dart';

import 'bottom_routes.dart';
import 'navigation.dart';

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
        visible: selectedPage > 2 ? false : true,
        child: CustomFloatingCircularButton(
          widthAndHeight: 60,
          onPressed: () {
            if (selectedPage == 0) {
              goToNewJob(context);
            } else if (selectedPage == 1) {
              goToNewNote(context);
            } else if (selectedPage == 2) {
              goToNewGroup(context);
            } else {
              print("not an option" + selectedPage.toString());
            }
          },
          iconData: CupertinoIcons.add,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: selectedPage == 3 ? null : CircularNotchedRectangle(),
        notchMargin: 16.0,
        child: buildRowOfNavBar(),
      ),
    );
  }

  Row buildRowOfNavBar() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        for (int i = 0; i < 2; i++) buildIBottomBarButton(i),
        Icon(null),
        for (int i = 2; i < 4; i++) buildIBottomBarButton(i),
      ],
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
