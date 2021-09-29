import 'package:hive/hive.dart';

import 'note.dart';

part 'reward.g.dart';

@HiveType(typeId: 5)
class Reward extends HiveObject {
  @HiveField(0)
  Note? note;
  @HiveField(1)
  int price = 2;
}
