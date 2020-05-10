import 'package:flex/models/sneaker.dart';
import 'package:flex/ui/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Values that this screen consumes:
//  -list of sneakers of current user
//  -display name of current user

//This screen is never pushed to navigation stack
//Parent: Home
class MyCollection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Sneaker> sneakers = Provider.of<List<Sneaker>>(context);
    String displayName = Provider.of<String>(context);

    if (sneakers.isEmpty) {
      return Center(
        child: Text(
          'Your collection is empty. Start adding to it by searching up your sneakers!',
          style: Theme
              .of(context)
              .textTheme
              .subtitle1,
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return Column(
        children: <Widget>[
          Collection(
            viewedUsersSneakers: sneakers,
            viewedUserDisplayName: displayName,
            currentUserDisplayName: displayName,
            showMenu: true,
            currentUserSameAsViewedUser: true,
          ),
        ],
      );
    }
  }
}
