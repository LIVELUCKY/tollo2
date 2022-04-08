import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tollo2/models/note.dart';
import 'package:tollo2/providers/note_model.dart';
import 'package:tollo2/services/formatters/date_full.dart';
import 'package:tollo2/widgets/components/CustomCard.dart';
import 'package:tollo2/widgets/components/drop_down.dart';
import 'package:tollo2/widgets/forms/newNote.dart';

import '../../services/textDirection.dart';

class ViewNote extends StatefulWidget {
  const ViewNote({Key? key, required this.note}) : super(key: key);
  final Note note;

  @override
  _ViewNoteState createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var note2 = widget.note.note;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(CupertinoIcons.back),
                    ),
                    IconButton(
                      onPressed: () async {
                        bool edited = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewNote(
                              note: widget.note,
                            ),
                          ),
                        );
                        if (edited) {
                          setState(() {});
                        }
                      },
                      icon: Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () async {
                        Provider.of<NoteModel>(context, listen: false)
                            .deleteNote(widget.note);
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        CupertinoIcons.trash_fill,
                        color: Colors.red.shade400,
                      ),
                    ),
                  ],
                ),
              ),
              CustomCard(
                  widget: Center(
                    child: Text(
                      formatFull(widget.note.createdAt),
                    ),
                  ),
                  size: size),
              CustomCard(
                  widget: DropDownCustom(widget: new Text(
                    note2,

                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationColor: Theme.of(context).primaryColor,
                        decorationStyle: TextDecorationStyle.solid,
                        backgroundColor:
                        Theme.of(context).backgroundColor.withAlpha(10),
                        height: size.aspectRatio * 2.8,
                        decorationThickness: size.aspectRatio * 2),
                    textAlign: isRTL(note2)
                      ? TextAlign.right
                      : TextAlign.left,

                  ), size: size),
                  size: size)
            ],
          ),
        ),
      ),
    );
  }
}
