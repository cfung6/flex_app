import 'package:flex/models/user.dart';
import 'package:flex/provider_notifiers/drawer_notifier.dart';
import 'package:flex/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<DrawerStateNotifier>(context);
    final user = Provider.of<User>(context);
    String userName;

    if (user == null) {
      userName = 'Not signed in';
    } else if (user.userInfo.isAnonymous) {
      userName = 'Anonymous';
    } else {
      userName = user.userInfo.uid;
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
              decoration: BoxDecoration(color: const Color(0xFFC13F4D)),
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
                      },
                    ),
                  ],
                ),
              ),
            ),
//            ListTile(
//              title: Text('Sign in / Register'),
//              leading: Image.asset(
//                'assets/images/login.png',
//                width: 20.0,
//              ),
//              onTap: () {
//                Navigator.of(context).pop();
//                notifier.updateScreen('Sign in / Register');
//              },
//            ),
            ListTile(
              title: Text('Search'),
              leading: Icon(
                Icons.search,
              ),
              onTap: () {
                Navigator.of(context).pop();
                notifier.updateScreen('Search');
              },
            ),
          ],
        ),
      ),
    );
  }
}
