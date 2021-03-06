import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:tollo2/models/note.dart';
import 'package:tollo2/providers/note_model.dart';
import 'package:tollo2/services/formatters/trimmer.dart';
import 'package:tollo2/services/sort_by_searched.dart';
import 'package:tollo2/widgets/components/CustomCard.dart';
import 'package:tollo2/widgets/components/drop_down.dart';
import 'package:tollo2/widgets/views/viewNote.dart';

import '../../services/formatters/date_full.dart';
import '../../services/textDirection.dart';

class NotesList extends StatefulWidget {
  const NotesList({Key? key}) : super(key: key);

  @override
  _NotesListState createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  String searched = '';
  late List<Note> notes;
  bool r = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    notes = Provider.of<NoteModel>(context).notes.reversed.toList();
    notes = sortNoteByString(notes, searched);
    return ListView.builder(
      itemCount: notes.length + 1,
      itemBuilder: (context, index) {
        if (index == 0)
          return Card(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          searched = value;
                          setState(() {
                            r = isRTL(value);
                          });
                        },
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: 'Search In Your Dairy',
                          // border: InputBorder.none,
                          // focusedBorder: UnderlineInputBorder(),
                        ),
                        textAlign: r ? TextAlign.right : TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        Note note = notes[index - 1];
        var text2 = trimTill(note.note, searched);
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewNote(note: note),
              ),
            );
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 0),
                child: Row(
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        formatFull(note.createdAt),
                        style: TextStyle(
                            fontSize: size.aspectRatio * 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              CustomCard(
                  widget: DropDownCustom(
                      widget: new SubstringHighlight(
                          text: text2,
                          term: searched,
                          textStyle: Theme.of(context).textTheme.bodyText1!,
                          textStyleHighlight: TextStyle(
                            backgroundColor:
                                Theme.of(context).primaryColorLight,
                          ),
                          textAlign:
                              isRTL(text2) ? TextAlign.right : TextAlign.left),
                      size: size / 4),
                  size: size),
            ],
          ),
        );
      },
    );
  }
}
