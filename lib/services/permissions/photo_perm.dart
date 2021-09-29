import 'package:permission_handler/permission_handler.dart';

Future<bool> checkPermissionsPhotos() async {
  var status = await Permission.photos.status;
  if (status.isDenied) {
    PermissionStatus perm = await Permission.photos.request();
    bool cond = perm.isGranted || perm.isLimited;
    return cond;
  }
  return true;
}
