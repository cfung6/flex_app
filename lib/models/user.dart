import 'package:firebase_auth/firebase_auth.dart';

class User {
  FirebaseUser userInfo;

  User({this.userInfo});

  @override
  String toString() {
    return this == null ? null : userInfo.toString();
  }
}