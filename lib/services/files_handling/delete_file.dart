import 'dart:io';

import 'package:tollo2/services/permissions/storage_perm.dart';

Future<bool> deleteFile(String filename) async {
  try {
    bool cond = await checkPermissionsStorage();
    if (cond) {
      File f = File(filename);
      await f.delete();
      return true;
    }
  } catch (e) {}
  return false;
}