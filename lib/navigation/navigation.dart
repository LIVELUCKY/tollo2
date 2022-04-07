import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tollo2/widgets/forms/newGroup.dart';
import 'package:tollo2/widgets/forms/newJob.dart';
import 'package:tollo2/widgets/forms/newNote.dart';

void goToNewGroup(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => NewGroup()),
  );
}

void goToNewNote(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => NewNote()),
  );
}

void goToNewJob(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => NewJob(
        edit: false,
      ),
    ),
  );
}
