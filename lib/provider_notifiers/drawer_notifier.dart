import 'package:flex/screens/my_collection.dart';
import 'package:flex/screens/search_sneakers.dart';
import 'package:flex/screens/search_users.dart';
import 'package:flutter/material.dart';

class DrawerStateNotifier with ChangeNotifier {
  String currentScreen = 'My Collection';

  Widget get getScreen {
    switch (currentScreen) {
      case 'Search Users':
        return SearchUsers();
      case 'Search Sneakers':
        return Search();
      case 'My Collection':
        return MyCollection();
      default:
        return null;
    }
  }

  void updateScreen(String newScreen) {
    currentScreen = newScreen;
    notifyListeners();
  }
}
