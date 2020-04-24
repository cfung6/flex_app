import 'package:flex/provider_notifiers/DrawerStateNotifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'file:///C:/Users/chris/StudioProjects/flex/lib/ui/my_drawer.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0.0,
        textTheme: Theme.of(context).textTheme,
        title: const Text('FLEX'),
        actions: <Widget>[],
      ),
      drawer: MyDrawer(),
      body: Consumer<DrawerStateNotifier>(
        builder: (context, navigationProvider, _) =>
            navigationProvider.getScreen,
      ),
    );
  }
}
