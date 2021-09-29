import 'dart:io';

import 'package:tollo2/services/files_handling/directory_getter.dart';

Future<String> saveImage(pickedFile) async {
  if (pickedFile == null) return '';
  final String imageName = DateTime.now().toUtc().toIso8601String() + '.jpg';
  String newPath = await getImageDir();
  File f = File(pickedFile.path);
  File x = await f.copy(newPath + '/$imageName');
  f.delete();
  return x.path;
}
