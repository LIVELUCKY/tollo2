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

//
//
// /// App widget class.
// class App extends StatelessWidget {
//   // Making list of pages needed to pass in IntroViewsFlutter constructor.
//   final pages = [
//     PageViewModel(
//       pageColor: const Color(0xFF353D40),
//       iconImageAssetPath: 'assets/house.png',
//       bubble: Image.asset('assets/house.png'),
//       body: const Text('Here you will find all Tollos '),
//       title: const Text(
//         'Home',
//       ),
//       titleTextStyle:
//           const TextStyle(fontFamily: 'MyFont', color: Colors.white),
//       bodyTextStyle: const TextStyle(fontFamily: 'MyFont', color: Colors.white),
//       mainImage: Image.asset(
//         'assets/house.png',
//         height: 300.0,
//         width: 500.0,
//         alignment: Alignment.center,
//       ),
//     ),
//     PageViewModel(
//       pageColor: const Color(0xFFD9D9D9),
//       iconImageAssetPath: 'assets/stack.png',
//       bubble: Image.asset('assets/stack.png'),
//       body: const Text('Here you can create Tollo Stacks'),
//       title: const Text(
//         'Stack',
//       ),
//       titleTextStyle:
//           const TextStyle(fontFamily: 'MyFont', color: Colors.white),
//       bodyTextStyle: const TextStyle(fontFamily: 'MyFont', color: Colors.white),
//       mainImage: Image.asset(
//         'assets/stack.png',
//         height: 300.0,
//         width: 500.0,
//         alignment: Alignment.center,
//       ),
//     ),
//     PageViewModel(
//       pageColor: const Color(0xFFA1A5A6),
//       iconImageAssetPath: 'assets/diary.png',
//       bubble: Image.asset('assets/diary.png'),
//       body: const Text('Here you can write your diary'),
//       title: const Text(
//         'Diary',
//       ),
//       titleTextStyle:
//           const TextStyle(fontFamily: 'MyFont', color: Colors.white),
//       bodyTextStyle: const TextStyle(fontFamily: 'MyFont', color: Colors.white),
//       mainImage: Image.asset(
//         'assets/diary.png',
//         height: 300.0,
//         width: 500.0,
//         alignment: Alignment.center,
//       ),
//     ),
//     PageViewModel(
//       pageColor: const Color(0xFFF2B138),
//       iconImageAssetPath: 'assets/gift.png',
//       bubble: Image.asset('assets/gift.png'),
//       body: const Text('Here you can add and buy Rewards(with enough points)'),
//       title: const Text(
//         'Rewards',
//       ),
//       titleTextStyle:
//           const TextStyle(fontFamily: 'MyFont', color: Colors.white),
//       bodyTextStyle: const TextStyle(fontFamily: 'MyFont', color: Colors.white),
//       mainImage: Image.asset(
//         'assets/gift.png',
//         height: 300.0,
//         width: 500.0,
//         alignment: Alignment.center,
//       ),
//     ),
//     PageViewModel(
//       pageColor: const Color(0xFF003F63),
//       iconImageAssetPath: 'assets/alarm.png',
//       bubble: Image.asset('assets/alarm.png'),
//       body: const Text('Here you can find all upcoming Alarms '),
//       title: const Text(
//         'Alarms',
//       ),
//       titleTextStyle:
//           const TextStyle(fontFamily: 'MyFont', color: Colors.white),
//       bodyTextStyle: const TextStyle(fontFamily: 'MyFont', color: Colors.white),
//       mainImage: Image.asset(
//         'assets/alarm.png',
//         height: 300.0,
//         width: 500.0,
//         alignment: Alignment.center,
//       ),
//     ),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'IntroViews Flutter',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: FutureBuilder<bool>(
//         future: firstRun(),
//         // async work
//         builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.waiting:
//               return Scaffold(body: CircularProgressIndicator());
//             default:
//               if (snapshot.hasError)
//                 return Text('Error: ${snapshot.error}');
//               else {
//                 if (snapshot.data!) {
//                   return IntroViewsFlutter(
//                     pages,
//                     onTapDoneButton: () {
// // Use Navigator.pushReplacement if you want to dispose the latest route
// // so the user will not be able to slide back to the Intro Views.
//                       Navigator.pushAndRemoveUntil(
//                           context,
//                           MaterialPageRoute(
//                               builder: (BuildContext context) => ),
//                           ModalRoute.withName('/'));
//                     },
//                     pageButtonTextStyles: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 18.0,
//                     ),
//                   );
//                 } else {
//                   return Tollo();
//                 }
//               }
//           }
//         },
//       ),
//     );
//   }
// }
// Builder(
// builder: (context) => IntroViewsFlutter(
// pages,
// onTapDoneButton: () {
//
// // Use Navigator.pushReplacement if you want to dispose the latest route
// // so the user will not be able to slide back to the Intro Views.
// Navigator.pushAndRemoveUntil(
// context,
// MaterialPageRoute(builder: (BuildContext context) => Tollo()),
// ModalRoute.withName('/'));
// },
// pageButtonTextStyles: const TextStyle(
// color: Colors.white,
// fontSize: 18.0,
// ),
// ),
// )
