import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:tollo2/widgets/lists/groups_grid.dart';
import 'package:tollo2/widgets/lists/jobs_alarms_list.dart';
import 'package:tollo2/widgets/lists/jobs_list.dart';
import 'package:tollo2/widgets/lists/notes_list.dart';
import 'package:tollo2/widgets/settings.dart';

final Map<Icon, Widget> routes = {
  Icon(CupertinoIcons.home): HomeList(),
  Icon(CupertinoIcons.book): NotesList(),
  Icon(CupertinoIcons.square_stack_3d_up): GroupsGrid(),
  Icon(CupertinoIcons.settings): SettingsWidget(),
};
