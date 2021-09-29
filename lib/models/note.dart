import 'package:hive/hive.dart';
part 'note.g.dart';

@HiveType(typeId: 3)
class Note extends HiveObject {
  @HiveField(0)
  String note = "";
  @HiveField(1)
  DateTime createdAt=DateTime.now();
}
