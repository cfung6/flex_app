import 'package:flutter/cupertino.dart';

import '../login.dart';
import '../search.dart';

class DrawerStateNotifier with ChangeNotifier {
  String _currentScreen = "Login";

  Widget get getScreen {
    switch (_currentScreen) {
      case 'Login':
        return Login();
      case 'Search':
        return SearchPage();
      default:
        return null;
    }
  }

  void updateScreen(String newScreen) {
    _currentScreen = newScreen;
    notifyListeners();
  }
}
