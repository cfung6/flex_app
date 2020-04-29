import 'package:firebase_auth/firebase_auth.dart';

class User {
  FirebaseUser userInfo;

  User({this.userInfo});

  @override
  String toString() {
    return this == null ? null : userInfo.toString();
  }

//  @override
//  bool operator ==(Object other) =>
//      identical(this, other) ||
//          other is User &&
//              runtimeType == other.runtimeType &&
//              userInfo.uid == other.userInfo.uid &&
//              userInfo.displayName == other.userInfo.displayName;
//
//  @override
//  int get hashCode => userInfo.hashCode;
}
