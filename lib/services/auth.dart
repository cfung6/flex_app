import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flex/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

//  final StreamController<FirebaseUser> _userReloadStreamController =
//      StreamController<FirebaseUser>.broadcast();
//  Stream<FirebaseUser> _onAuthStateChangedOrUserReload;
//
//  Auth() {
//    _onAuthStateChangedOrUserReload =
//        _mergeStreamWithUserReload(_auth.onAuthStateChanged);
//
//    _onAuthStateChangedOrUserReload.listen((event) {
//      log(
//          "Notifying user AND auth state listeners about user (display name: ${event
//              .displayName})");
//    });
//  }

  Future<User> signInAnon() async {
    try {
      AuthResult res = await _auth.signInAnonymously();
      //TODO: Update displayName if anon
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

  Future<User> signInWithEmail(String email, String password) async {
    AuthResult res = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    await updateDisplayNameLocal(res.user.displayName);
    return _createUser(res.user);
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
    //TODO: Update document id if changing display name
    try {
      UserUpdateInfo userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = displayName;
      FirebaseUser user = await _auth.currentUser();

      await user.updateProfile(userUpdateInfo);
      await user.reload();
      user = await _auth.currentUser();

//      _userReloadStreamController.add(user);
      await updateDisplayNameLocal(displayName);
      return User(userInfo: user);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<User> currentUser() async {
    try {
      FirebaseUser user = await _auth.currentUser();
      return User(userInfo: user);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }


  Stream<User> get user {
//    return _onAuthStateChangedOrUserReload.map(_createUser);
    return _auth.onAuthStateChanged.map(_createUser);
  }

  Future<void> updateDisplayNameLocal(String displayName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('displayName', displayName);
  }

  Future<String> getDisplayName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('displayName');
  }

  Future<String> getDisplayNameFromFirebase() async {
    FirebaseUser user = await _auth.currentUser();
    return user.displayName;
  }

//  Stream<FirebaseUser> _mergeStreamWithUserReload(Stream<FirebaseUser> stream) {
//    return Rx.merge([stream, _userReloadStreamController.stream]).publishValue()
//      ..connect();
//  }

  User _createUser(FirebaseUser user) {
    return user == null ? null : User(userInfo: user);
  }
}
