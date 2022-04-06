import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tollo2/providers/balance_model.dart';
import 'package:tollo2/providers/groups_model.dart';
import 'package:tollo2/providers/job_model.dart';
import 'package:tollo2/providers/note_model.dart';

import 'lists/jobs_alarms_list.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({Key? key}) : super(key: key);

  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(90.0, 75.0, 90.0, 12.0),
          child: Column(
            children: [
              Icon(
                CupertinoIcons.settings_solid,
                size: size.width / 4,
                color: Theme.of(context).buttonColor,
              ),
              createLine([
                Text('Dark Theme:'),
                Switch(
                  value: Theme.of(context).brightness == Brightness.dark,
                  onChanged: (value) {
                    EasyDynamicTheme.of(context).changeTheme();
                  },
                )
              ]),
              Divider(),
              createLine([
                Text('Active Alarms'),
                IconButton(
                    onPressed: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JobsAlarmsList(),
                        ),
                      );

                    },
                    icon: Icon(CupertinoIcons.alarm,size: 30,)),
              ]),
              createLine([
                Text('Current Balance:'),
                FutureBuilder<int>(
                  future: Provider.of<BalanceModel>(context).current(),
                  // async work
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Text('Loading....');
                      default:
                        if (snapshot.hasError)
                          return Text('Error: ${snapshot.error}');
                        else
                          return Text('${snapshot.data.toString()}');
                    }
                  },
                )
              ]),
              Divider(),
              createLine([
                Text('Total Tollos:'),
                Text('${Provider.of<JobModel>(context).jobs.length}'),
              ]),
              Divider(),
              createLine([
                Text('Total Tollo Stacks:'),
                Text('${Provider.of<GroupModel>(context).categories.length}'),
              ]),
              Divider(),
              createLine([
                Text('Total Notes:'),
                Text('${Provider.of<NoteModel>(context).notes.length}'),
              ]),
              Divider(),
              createLine([
                Text('Total Records:'),
                Text(
                    '${Provider.of<JobModel>(context).getAudiosTotal().length}'),
              ]),
              Divider(),
              createLine([
                Text('Total Images:'),
                Text(
                    '${Provider.of<JobModel>(context).getImagesTotal().length}'),
              ]),
              Divider(),
              createLine([
                Text('Total ON Reminders:'),
                Text(
                    '${Provider.of<JobModel>(context).getTotalRemindersLength()}'),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget createLine(List<Widget> widgets) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: widgets,
      ),
    );
  }
}
