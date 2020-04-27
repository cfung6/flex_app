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

  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  ///throws: FirebaseAuthWeakPasswordException,
  ///        FirebaseAuthInvalidCredentialsException,
  ///        FirebaseAuthUserCollisionException
  Future<User> register(String email, String password,
      String displayName) async {
    AuthResult res = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return User(userInfo: res.user);
  }

  Future<User> updateDisplayName(String displayName) async {
    try {
      UserUpdateInfo userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = displayName;
      FirebaseUser user = await _auth.currentUser();

      log('1');
      await user.updateProfile(userUpdateInfo);
      await user.reload();
      user = await _auth.currentUser();
      log('2');
      return User(userInfo: user);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_createUser);
  }

  User _createUser(FirebaseUser user) {
    return user == null ? null : User(userInfo: user);
  }
}
