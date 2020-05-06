import 'package:flex/models/user.dart';
import 'package:flex/provider_notifiers/drawer_notifier.dart';
import 'package:flex/services/auth.dart';
import 'package:flex/wrappers/auth_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    final drawerNotifier =
    Provider.of<DrawerStateNotifier>(context, listen: false);
    final user = Provider.of<User>(context);
    final displayName = Provider.of<String>(context);
    String userName;

    if (user == null) {
      userName = 'Not signed in';
    } else if (user.userInfo.isAnonymous) {
      userName = 'Anonymous';
    } else {
      userName = displayName;
    }

    return SafeArea(
      child: Drawer(
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
                    const SizedBox(height: 5.0),
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
                            MaterialPageRoute(builder: (_) => AuthWrapper()),
                                (r) => false);
                      },
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: const Text('Search Users'),
              leading: const Icon(
                Icons.person,
              ),
              onTap: () {
                Navigator.of(context).pop();
                drawerNotifier.updateScreen('Search Users');
              },
            ),
            ListTile(
              title: const Text('Search Sneakers'),
              leading: const Icon(
                Icons.search,
              ),
              onTap: () {
                Navigator.of(context).pop();
                drawerNotifier.updateScreen('Search Sneakers');
              },
            ),
            ListTile(
              title: const Text('My Collection'),
              leading: Image.asset(
                'assets/images/yeezy.png',
                width: 35.0,
              ),
              onTap: () {
                Navigator.of(context).pop();
                drawerNotifier.updateScreen('My Collection');
              },
            ),
          ],
        ),
      ),
    );
  }
}
