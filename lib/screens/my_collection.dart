import 'package:flex/models/sneaker.dart';
import 'package:flex/ui/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyCollection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Sneaker> sneakers = Provider.of<List<Sneaker>>(context);
    String displayName = Provider.of<String>(context);

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
