import 'package:flex/provider_notifiers/DrawerStateNotifier.dart';
import 'package:flex/ui/my_appbar.dart';
import 'package:flex/ui/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
          title: Provider
              .of<DrawerStateNotifier>(context)
              .currentScreen),
      drawer: MyDrawer(),
      body: Consumer<DrawerStateNotifier>(
        builder: (context, navigationProvider, _) =>
            navigationProvider.getScreen,
      ),
    );
  }
}
