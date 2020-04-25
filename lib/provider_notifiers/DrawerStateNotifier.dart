import 'package:flutter/material.dart';

import '../screens/login.dart';
import '../screens/search.dart';

class DrawerStateNotifier with ChangeNotifier {
  String currentScreen = "Login";

  Widget get getScreen {
    switch (currentScreen) {
      case 'Login':
        return Login();
      case 'Search':
        return Search();
      default:
        return null;
    }
  }

  void updateScreen(String newScreen) {
    currentScreen = newScreen;
    notifyListeners();
  }
}
