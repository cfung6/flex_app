import 'package:flutter/material.dart';

import '../screens/search.dart';

class DrawerStateNotifier with ChangeNotifier {
  String currentScreen = 'Search';

  Widget get getScreen {
    switch (currentScreen) {
//      case 'Sign in / Register':
//        return ContinueWith();
//      case 'Login':
//        return Login();
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
