import 'package:flex/screens/collection.dart';
import 'package:flutter/material.dart';

import '../screens/search.dart';

class DrawerStateNotifier with ChangeNotifier {
  String currentScreen = 'Search';

  Widget get getScreen {
    switch (currentScreen) {
      case 'Search':
        return Search();
      case 'Collection':
        return Collection();
      default:
        return null;
    }
  }

  void updateScreen(String newScreen) {
    currentScreen = newScreen;
    notifyListeners();
  }
}
