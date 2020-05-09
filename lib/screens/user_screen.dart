import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flex/models/sneaker.dart';
import 'package:flex/services/database_helper.dart';
import 'package:flex/ui/collection.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  final DocumentSnapshot doc;

  //if the current user is friends with the user being viewed
  final bool areFriends;

  final List<Sneaker> currentUserSneakers;
  final String currentUserDisplayName;

  UserScreen({
    @required this.doc,
    @required this.areFriends,
    @required this.currentUserSneakers,
    @required this.currentUserDisplayName
  });

  @override
  Widget build(BuildContext context) {
    String userDisplayName = DatabaseHelper('').getDisplayNameFromDoc(doc);
    List<Sneaker> sneakers =
    DatabaseHelper(userDisplayName).snapshotToSneakerList(doc);

    return Scaffold(
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
                .copyWith(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 10.0),
          _displayFriendButton(),
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
            currentUserSneakers: currentUserSneakers,
            currentUserDisplayName: currentUserDisplayName,
            showMenu: false,
            currentUserSameAsViewedUser: false,
          ),
        ],
      ),
    );
  }

  Widget _displayFriendButton() {
    return Align(
      child: RaisedButton(
        onPressed: () {},
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.person_add),
            const SizedBox(width: 10.0),
            const Text('Add friend'),
          ],
        ),
        color: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      ),
    );
  }
}
