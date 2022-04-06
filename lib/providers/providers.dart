import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tollo2/providers/balance_model.dart';
import 'package:tollo2/providers/groups_model.dart';
import 'package:tollo2/providers/note_model.dart';


import 'job_model.dart';

List<SingleChildWidget> providers() {
  return [
    ChangeNotifierProvider<JobModel>(create: (_) => JobModel()),
    ChangeNotifierProvider<GroupModel>(create: (_) => GroupModel()),
    ChangeNotifierProvider<NoteModel>(create: (_) => NoteModel()),
    ChangeNotifierProvider<BalanceModel>(create: (_) => BalanceModel()),
  ];
}
