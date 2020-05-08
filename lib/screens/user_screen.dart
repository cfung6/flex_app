import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flex/services/database_helper.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatefulWidget {
  final DocumentSnapshot doc;

  //if the current user is friends with the user being viewed
  final bool areFriends;

  UserScreen({
    @required this.doc,
    @required this.areFriends,
  });

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  String _userDisplayName;
  bool areFriends;

  @override
  void initState() {
    _userDisplayName = DatabaseHelper('').getDisplayNameFromDoc(widget.doc);
    areFriends = widget.areFriends;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(height: 30.0),
          Image.asset(
            'assets/images/no_image.png',
            height: 200.0,
          ),
          Text(
            _userDisplayName,
            textAlign: TextAlign.center,
            style: Theme
                .of(context)
                .textTheme
                .headline4
                .copyWith(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 20.0),
          _displayFriendButton(),
          SizedBox(height: 20.0),
          const Divider(
            thickness: 3.0,
            indent: 90.0,
            endIndent: 90.0,
          ),
          SizedBox(height: 20.0),
          Text(
            'Collection',
            textAlign: TextAlign.center,
            style: Theme
                .of(context)
                .textTheme
                .headline6,
          ),
          SizedBox(height: 20.0),
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
            Icon(Icons.person_add),
            SizedBox(width: 10.0),
            Text('Add friend'),
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
