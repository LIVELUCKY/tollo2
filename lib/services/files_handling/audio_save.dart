import 'dart:io';

import 'package:tollo2/services/files_handling/directory_getter.dart';

Future<String> saveSound() async {
  final String soundName = DateTime.now().toUtc().toIso8601String() + '.m4a';

  String newPath = await getAudioDir();
  File f = await File(newPath + '/$soundName').create(recursive: true);
  return f.path;
}
