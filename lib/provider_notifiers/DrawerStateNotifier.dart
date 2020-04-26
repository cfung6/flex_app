import 'package:flex/screens/continue_with.dart';
import 'package:flutter/material.dart';

import '../screens/login.dart';
import '../screens/search.dart';

class DrawerStateNotifier with ChangeNotifier {
  String currentScreen = 'Sign in / Register';

  Widget get getScreen {
    switch (currentScreen) {
      case 'Sign in / Register':
        return ContinueWith();
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
