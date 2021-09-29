import 'dart:io';

Future<File?> getLocalFile(String filename) async {
  File f = File(filename);
  return f;
}