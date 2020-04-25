import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flex/models/user.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User> signInAnon() async {
    try {
      AuthResult res = await _auth.signInAnonymously();
      return User(userInfo: res.user);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
