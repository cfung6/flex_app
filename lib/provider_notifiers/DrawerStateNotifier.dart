import 'package:flutter/cupertino.dart';

import '../pages/login.dart';
import '../pages/search.dart';

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
