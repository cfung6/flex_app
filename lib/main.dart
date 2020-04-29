import 'package:flex/auth_listener.dart';
import 'package:flex/provider_notifiers/drawer_notifier.dart';
import 'package:flex/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'models/user.dart';
import 'ui/colors.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final ThemeData _theme = _buildTheme();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: MaterialApp(
        title: 'Flex App',
        theme: _theme,
        home: AuthListener(),
      ),
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<DrawerStateNotifier>(
          create: (_) => DrawerStateNotifier(),
        ),
        StreamProvider<User>.value(
          value: Auth().user,
          updateShouldNotify: (previous, current) => previous != current,
        ),
      ],
    );
  }
}

ThemeData _buildTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    primaryColor: jordanRed,
    accentColor: jordanRed,
    buttonTheme: ButtonThemeData(
      buttonColor: jordanRed,
      colorScheme: base.colorScheme.copyWith(
        primary: jordanRed,
        secondary: jordanRed,
      ),
      textTheme: ButtonTextTheme.primary,
    ),
  );
}
