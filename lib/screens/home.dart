import 'package:flex/provider_notifiers/drawer_notifier.dart';
import 'package:flex/services/auth.dart';
import 'package:flex/ui/my_appbar.dart';
import 'package:flex/ui/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureProvider<String>.value(
      value: Auth().getDisplayNameFromFirebase(),
      child: Scaffold(
        appBar: MyAppBar(
            title: Provider
                .of<DrawerStateNotifier>(context)
                .currentScreen),
        drawer: MyDrawer(),
        body: Consumer<DrawerStateNotifier>(
          builder: (context, navigationProvider, _) =>
          navigationProvider.getScreen,
        ),
      ),
    );
  }
}
