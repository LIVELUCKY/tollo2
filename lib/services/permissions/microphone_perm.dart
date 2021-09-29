import 'package:permission_handler/permission_handler.dart';

Future<bool> checkPermissionsMicrophone() async {
  var status = await Permission.microphone.status;
  if (status.isDenied) {
    PermissionStatus perm = await Permission.microphone.request();
    bool cond = perm.isGranted || perm.isLimited;
    return cond;
  }
  return true;
}
