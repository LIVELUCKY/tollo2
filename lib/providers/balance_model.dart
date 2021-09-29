import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BalanceModel extends ChangeNotifier {
  addBalance(int amount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int balance = (prefs.getInt('balance') ?? 0) + amount;
    await prefs.setInt('balance', balance);
    notifyListeners();
  }

  subBalance(int amount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int balance = (prefs.getInt('balance') ?? 0) - amount;
    await prefs.setInt('balance', balance);
    notifyListeners();
  }

  Future<int> current() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getInt('balance') ?? 0);
  }
}
