import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> getDir(String folder) async {
  Directory? directory;
  directory = await getApplicationDocumentsDirectory();
  String newPath = directory.path;
  newPath = newPath + folder;
  directory = Directory(newPath);
  if (!await directory.exists()) {
    await directory.create(recursive: true);
  }
  return newPath;
}

Future<String> getImageDir() async {
  String newPath = await getDir("/images");
  return newPath;
}

Future<String> getAudioDir() async {
  String newPath = await getDir("/audio");
  return newPath;
}
