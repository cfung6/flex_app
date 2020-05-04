import 'dart:developer';

import 'package:flex/models/sneaker.dart';
import 'package:flex/provider_notifiers/drawer_notifier.dart';
import 'package:flex/services/database_helper.dart';
import 'package:flex/ui/my_appbar.dart';
import 'package:flex/ui/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final displayName = Provider.of<String>(context);

    return StreamProvider.value(
      value: DatabaseHelper(displayName: displayName).getSneakerCollection(),
      initialData: List<Sneaker>(),
      catchError: (_, error) {
        log(error.toString());
        return List<Sneaker>();
      },
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
