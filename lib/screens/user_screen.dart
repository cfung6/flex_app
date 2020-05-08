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

  @override
  void initState() {
    _userDisplayName = DatabaseHelper('').getDisplayNameFromDoc(widget.doc);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
