import 'package:flex/provider_notifiers/DrawerStateNotifier.dart';
import 'package:flex/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: MaterialApp(
        title: 'Flex App',
        home: Home(),
      ),
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<DrawerStateNotifier>(
          create: (_) => DrawerStateNotifier(),
        ),
      ],
    );
  }
}
