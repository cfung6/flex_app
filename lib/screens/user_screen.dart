import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flex/models/sneaker.dart';
import 'package:flex/services/database_helper.dart';
import 'package:flex/ui/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'loading.dart';

class UserScreen extends StatefulWidget {
  final DocumentSnapshot doc;
  final String currentUserDisplayName;

  UserScreen({
    @required this.doc,
    @required this.currentUserDisplayName,
  });

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    String userDisplayName =
    DatabaseHelper('').getDisplayNameFromDoc(widget.doc);
    List<Sneaker> sneakers =
    DatabaseHelper(userDisplayName).snapshotToSneakerList(widget.doc);
    List<String> friends = Provider.of<List<String>>(context);

    return _loading
        ? Loading()
        : Scaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(height: 20.0),
          Image.asset(
            'assets/images/no_image.png',
            height: 150.0,
          ),
          Text(
            userDisplayName,
            textAlign: TextAlign.center,
            style: Theme
                .of(context)
                .textTheme
                .headline4
                .copyWith(
                fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 10.0),
          _displayFollowButton(
              userDisplayName, friends.contains(userDisplayName)),
          const SizedBox(height: 10.0),
          const Divider(
            thickness: 3.0,
            indent: 90.0,
            endIndent: 90.0,
          ),
          const SizedBox(height: 10.0),
          Text(
            'Collection',
            textAlign: TextAlign.center,
            style: Theme
                .of(context)
                .textTheme
                .headline6,
          ),
          const SizedBox(height: 10.0),
          Collection(
            viewedUsersSneakers: sneakers,
            viewedUserDisplayName: userDisplayName,
            currentUserDisplayName: widget.currentUserDisplayName,
            showMenu: false,
            currentUserSameAsViewedUser: false,
          ),
        ],
      ),
    );
  }

  Widget _displayFollowButton(String displayName, bool areFriends) {
    if (widget.currentUserDisplayName == displayName) {
      return Container(
        height: 0,
        width: 0,
      );
    }
    return areFriends
        ? Align(
      child: RaisedButton(
        onPressed: () async {
          setState(() => _loading = true);
          if (!(await DatabaseHelper(widget.currentUserDisplayName)
              .unfollow(displayName))) {
            log('Error unfollowing');
            //TODO: Error
          }
          setState(() => _loading = false);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              'assets/images/remove_friend.png',
              height: 30.0,
            ),
            const SizedBox(width: 10.0),
            const Text('Unfollow'),
          ],
        ),
        color: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        padding:
        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      ),
    )
        : Align(
      child: RaisedButton(
        onPressed: () async {
          setState(() => _loading = true);
          if (!(await DatabaseHelper(widget.currentUserDisplayName)
              .follow(displayName))) {
            log('Error following');
            //TODO: Error
          }
          setState(() => _loading = false);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.person_add),
            const SizedBox(width: 10.0),
            const Text('Follow'),
          ],
        ),
        color: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        padding:
        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      ),
    );
  }
}
