import 'package:flex/provider_notifiers/DrawerStateNotifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navigation = Provider.of<DrawerStateNotifier>(context);

    return SafeArea(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('chris'),
              accountEmail: Text(''),
            ),
            ListTile(
              title: Text('Login/Register'),
              onTap: () {
                Navigator.of(context).pop();
                navigation.updateScreen('Login');
              },
            ),
            ListTile(
              title: Text('Search'),
              onTap: () {
                Navigator.of(context).pop();
                navigation.updateScreen('Search');
              },
            ),
          ],
        ),
      ),
    );
  }
}
