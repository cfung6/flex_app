import 'package:flex/auth_listener.dart';
import 'package:flex/models/user.dart';
import 'package:flex/provider_notifiers/drawer_notifier.dart';
import 'package:flex/screens/loading.dart';
import 'package:flex/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    final drawerNotifier =
    Provider.of<DrawerStateNotifier>(context, listen: false);
    final user = Provider.of<User>(context);
    String userName;

    if (user == null) {
      userName = 'Not signed in';
    } else if (user.userInfo.isAnonymous) {
      userName = 'Anonymous';
    } else {
      userName = user.userInfo.displayName;
    }

    return SafeArea(
      child: userName == null
          ? _buildFutureDrawer(drawerNotifier)
          : _buildDrawer(context, userName, drawerNotifier),
    );
  }

  //if user data hasn't updated locally, ask Firebase Auth for the current user data
  Widget _buildFutureDrawer(DrawerStateNotifier drawerNotifier) {
    return FutureBuilder(
      future: _auth.getDisplayName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError || snapshot.data == null) {
            return _buildDrawer(context, 'Not signed in', drawerNotifier);
          } else {
            return _buildDrawer(
                context, snapshot.data, drawerNotifier);
          }
        } else {
          return Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Loading(),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildDrawer(BuildContext context, String userName,
      DrawerStateNotifier drawerNotifier) {
    return Drawer(
      child: ListView(
        children: <Widget>[
//            UserAccountsDrawerHeader(
//              accountName: Text('chris'),
//              accountEmail: Text(''),
//            ),
          DrawerHeader(
            decoration: BoxDecoration(color: Theme
                .of(context)
                .primaryColor),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    userName,
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: Colors.white),
                  ),
                  SizedBox(height: 5.0),
                  FlatButton(
                    child: Text(
                      'Sign out',
                      style: Theme
                          .of(context)
                          .textTheme
                          .subtitle2
                          .copyWith(
                        color: Colors.cyan[400],
                        fontSize: 15.0,
                      ),
                    ),
                    onPressed: () async {
                      await _auth.signOut();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => AuthListener()),
                              (r) => false);
                    },
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: Text('Search'),
            leading: Icon(
              Icons.search,
            ),
            onTap: () {
              Navigator.of(context).pop();
              drawerNotifier.updateScreen('Search');
            },
          ),
          ListTile(
            title: Text('My collection'),
            leading: Image.asset(
              'assets/images/yeezy.png',
              width: 35.0,
            ),
            onTap: () {
              Navigator.of(context).pop();
              drawerNotifier.updateScreen('Collection');
            },
          ),
        ],
      ),
    );
  }
}
