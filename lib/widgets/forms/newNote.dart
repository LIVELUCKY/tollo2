import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tollo2/models/note.dart';
import 'package:tollo2/providers/note_model.dart';

import '../../services/textDirection.dart';


class NewNote extends StatefulWidget {
  const NewNote({Key? key, this.note}) : super(key: key);
  final Note? note;

  @override
  _NewNoteState createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _controllerDescription;
  late Note note;
  bool jobdesdir = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.note != null) {
      note = widget.note!;
    } else {
      note = Note();
    }
    _controllerDescription = new TextEditingController(text: note.note);
    _controllerDescription.addListener(() {
      setState(() {
        jobdesdir = isRTL(_controllerDescription.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(CupertinoIcons.chevron_down),
                      )
                    ],
                  ),
                  TextFormField(
                    controller: _controllerDescription,
                    minLines: 2,
                    maxLines: null,
                    autofocus: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter a Description';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter a Note Description',
                      border: InputBorder.none,
                      focusedBorder: UnderlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.next,
                    textAlign: jobdesdir ? TextAlign.right : TextAlign.left,
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          note.note = _controllerDescription.text;

                          if (widget.note == null) {
                            Provider.of<NoteModel>(context, listen: false)
                                .addNote(note);
                          } else {
                            Provider.of<NoteModel>(context, listen: false)
                                .updateNote(note);
                          }
                          Navigator.pop(context, true);
                        }
                      },
                      child: Icon(Icons.save),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
