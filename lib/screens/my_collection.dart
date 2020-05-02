import 'dart:developer';

import 'package:flex/models/sneaker.dart';
import 'package:flex/screens/loading.dart';
import 'package:flex/services/auth.dart';
import 'package:flex/services/database_helper.dart';
import 'package:flutter/material.dart';

class MyCollection extends StatefulWidget {
  @override
  _MyCollectionState createState() => _MyCollectionState();
}

class _MyCollectionState extends State<MyCollection> {
  final Auth auth = Auth();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: auth.getDisplayName(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            //TODO: return error ui
            return Container();
          } else {
            return _buildStreamBuilder(snapshot.data);
          }
        } else {
          return Column(
            children: <Widget>[
              Expanded(
                child: Loading(),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildStreamBuilder(String displayName) {
    return StreamBuilder<List<Sneaker>>(
      stream: DatabaseHelper(displayName: displayName).getSneakerCollection(),
      initialData: List<Sneaker>(),
      builder: (_, snapshot) {
        for (Sneaker s in snapshot.data) {
          log(s.name);
        }
        if (snapshot.hasError) {
          //TODO: return error ui
          return Container();
        } else {
          return _buildCollectionList(snapshot.data);
        }
      },
    );
  }

  Widget _buildCollectionList(List<Sneaker> sneakers) {
    return ListView.builder(
      itemBuilder: (_, i) {
        return ListTile(
          title: Text(sneakers[i].name),
        );
      },
      itemCount: sneakers.length,
    );
  }
}
