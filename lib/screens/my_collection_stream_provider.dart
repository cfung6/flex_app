import 'dart:developer';

import 'package:flex/models/sneaker.dart';
import 'package:flex/screens/my_collection.dart';
import 'package:flex/services/auth.dart';
import 'package:flex/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyCollectionStreamProvider extends StatefulWidget {
  @override
  _MyCollectionStreamProviderState createState() =>
      _MyCollectionStreamProviderState();
}

class _MyCollectionStreamProviderState
    extends State<MyCollectionStreamProvider> {
  final Auth auth = Auth();

  @override
  Widget build(BuildContext context) {
    final displayName = Provider.of<String>(context);

    return StreamProvider<List<Sneaker>>.value(
      value: DatabaseHelper(displayName: displayName).getSneakerCollection(),
      initialData: List<Sneaker>(),
      catchError: (_, error) {
        log(error.toString());
        return List<Sneaker>();
      },
      child: MyCollection(),
    );
  }
}
