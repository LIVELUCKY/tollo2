import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:tollo2/models/note.dart';

class NoteModel extends ChangeNotifier {
  List<Note> notes = [];
  var notesBox = Hive.box<Note>('notes');

  NoteModel() {
    updateNotes();
  }

  void updateNotes() {
    notes = notesBox.values.toList();
    notifyListeners();
  }

  addNote(Note note) async {
    await notesBox.add(note);
    updateNotes();
  }

  deleteNote(Note note) async {
    await notesBox.delete(note.key);
    updateNotes();
  }

  updateNote(Note note) async {
    await note.save();
    updateNotes();
  }
}
