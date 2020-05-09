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
          sneakers: sneakers,
          displayName: displayName,
          showMenu: true,
          allContained: true,
        ),
      ],
    );
  }
}
