import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:tollo2/navigation/navigator.dart';
import 'package:tollo2/providers/providers.dart';

var lightThemeData = new ThemeData(
    primaryColor: Colors.indigo,
    textTheme: new TextTheme(button: TextStyle(color: Colors.white70)),
    brightness: Brightness.light,
    accentColor: Colors.indigoAccent);

var darkThemeData = ThemeData(
    primaryColor: Colors.indigo,
    textTheme: new TextTheme(button: TextStyle(color: Colors.black54)),
    brightness: Brightness.dark,
    accentColor: Colors.indigoAccent);

class Tollo extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      child: ThemeConsumer(
        child: MultiProvider(
          providers: providers(),
          child: Builder(
            builder: (context) {
              return MaterialApp(
                title: 'Tollo',
                theme: lightThemeData,
                darkTheme: darkThemeData,
                themeMode: EasyDynamicTheme.of(context).themeMode,
                home: BottomMainNavigator(),
                debugShowCheckedModeBanner: false,
              );
            },
          ),
        ),
      ),
    );
  }
}
