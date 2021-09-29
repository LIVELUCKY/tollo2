import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:tollo2/models/job.dart';
import 'package:tollo2/models/reminder.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> registerNotification(Job job, Reminder reminder) async {
  await initializetimezone();
  print('bloblo' + reminder.key.toString());
  print('bloblo' + job.key.toString());
  print('bloblo' + reminder.clockBegin!.microsecondsSinceEpoch.toString());
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'alarm_notif',
    'alarm_notif',
    'Channel for Alarm notification',
    icon: 'codex_logo',
    playSound: true,
    largeIcon: DrawableResourceAndroidBitmap('codex_logo'),
    visibility: NotificationVisibility.public,
    enableLights: true,
    importance: Importance.max,
    enableVibration: true,
    priority: Priority.high,
    ongoing: true,
  );

  var platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.zonedSchedule(
      reminder.clockBegin!.microsecond,
      'Reminder',
      job.note!.note,
      tz.TZDateTime.from(
        reminder.clockBegin!,
        tz.local,
      ),
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true);
}

Future<void> deleteNotification(Reminder reminder) async {
  await flutterLocalNotificationsPlugin.cancel(reminder.clockBegin!.microsecond);
}

Future initializetimezone() async {
  tz.initializeTimeZones();
}
