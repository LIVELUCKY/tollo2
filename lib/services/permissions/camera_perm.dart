import 'package:permission_handler/permission_handler.dart';

Future<bool> checkPermissionsCamera() async {
  var status = await Permission.camera.status;
  if (status.isDenied) {
    PermissionStatus perm = await Permission.camera.request();
    bool cond = perm.isGranted || perm.isLimited;
    return cond;
  }
  return true;
}
