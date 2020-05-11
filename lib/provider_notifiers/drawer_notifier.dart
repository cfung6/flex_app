import 'package:flex/screens/my_collection.dart';
import 'package:flex/screens/my_profile.dart';
import 'package:flex/screens/search_sneakers.dart';
import 'package:flex/screens/search_users.dart';
import 'package:flutter/material.dart';

class DrawerStateNotifier with ChangeNotifier {
  String currentScreen = 'My Profile';

  Widget get getScreen {
    switch (currentScreen) {
      case 'Search Users':
        return SearchUsers();
      case 'Search Sneakers':
        return SearchSneakers();
      case 'My Collection':
        return MyCollection();
      case 'My Profile':
        return MyProfile();
      default:
        return null;
    }
  }

  void updateScreen(String newScreen) {
    currentScreen = newScreen;
    notifyListeners();
  }
}
