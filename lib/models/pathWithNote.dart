import 'package:hive/hive.dart';
import 'package:tollo2/models/note.dart';

part 'pathWithNote.g.dart';

@HiveType(typeId: 8)
class PathWNote extends Note {
  @HiveField(2)
  String path;

  PathWNote(this.path);
}
