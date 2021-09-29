import 'package:permission_handler/permission_handler.dart';

Future<bool> checkPermissionsStorage() async {
  var status = await Permission.storage.status;
  if (status.isDenied) {
    PermissionStatus perm = await Permission.storage.request();
    bool cond = perm.isGranted || perm.isLimited;
    return cond;
  }
  return true;
}
