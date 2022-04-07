import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tollo2/services/hive_db_mangae/adapter_registration.dart';
import 'package:tollo2/services/hive_db_mangae/open_boxes.dart';
import 'package:tollo2/services/notification.dart';
import 'package:tollo2/tollo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  adapterRegistration();
  await openBoxes();
  var initializationSettingsAndroid =
      AndroidInitializationSettings('codex_logo');
  var initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: (payload) async {},
  );

  runApp(EasyDynamicThemeWidget(child: Tollo()));
}
