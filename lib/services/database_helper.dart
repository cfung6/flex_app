import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flex/models/sneaker.dart';

class DatabaseHelper {
  final CollectionReference _userCollection =
  Firestore.instance.collection('users');
  String _upperCaseName;
  String _displayName;

  //All display names are converted to upper case as document ids to ensure
  //uniqueness of display names ignoring capitalization
  DatabaseHelper(String displayName) {
    if (displayName != null) {
      _displayName = displayName;
      _upperCaseName = displayName.toUpperCase();
    }
  }

  Stream<List<Sneaker>> getSneakerCollection() {
    return _userCollection
        .document(_upperCaseName)
        .snapshots()
        .map(_snapshotToSneakerList);
  }

  List<Sneaker> getSneakerCollectionFromDoc(DocumentSnapshot doc) {
    return _snapshotToSneakerList(doc);
  }

  //DocumentSnapshot returns in the form of:
  //{
  //  sneakers: {...},
  //  otherProperty: {...},
  //}
  List<Sneaker> _snapshotToSneakerList(DocumentSnapshot doc) {
    List<Sneaker> sneakerList = [];

    if (doc.data['sneakers'] == null) {
      return sneakerList;
    }

    //sneakerData is in the form of:
    //{
    //  "jordan 1": {...},
    //  "jordan 4": {...},
    //}
    Map<String, dynamic> sneakerData =
    Map<String, dynamic>.from(doc.data['sneakers']);

    if (sneakerData == null) {
      return sneakerList;
    }

    //for every shoe in the sneakerData map, we turn the key/value pair
    //into a sneaker object (key representing the name of the shoe and
    //value representing another map containing other sneaker
    //information other than the name such as price, releaseData, etc)
    sneakerData.forEach((key, value) {
      sneakerList.add(
        Sneaker.fromMap(key, Map<String, dynamic>.from(value)),
      );
    });

    return sneakerList;
  }

  //returns true if sneaker was added to collection successfully
  Future<bool> addSneakerToCollection(Sneaker sneaker) async {
    try {
      await _userCollection.document(_upperCaseName).setData(
        {
          'sneakers': {
            sneaker.name: {
              'price': sneaker.price,
              'releaseDate': sneaker.releaseDate,
              'bigImage': sneaker.bigImage,
              'medImage': sneaker.medImage,
              'smallImage': sneaker.smallImage,
            }
          }
        },
        merge: true,
      );
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> removeSneakerFromCollection(Sneaker sneaker) async {
    try {
      await _userCollection.document(_upperCaseName).updateData({
        'sneakers.${sneaker.name}': FieldValue.delete(),
      });
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Stream<List<String>> getFriends() {
    return _userCollection
        .document(_upperCaseName)
        .snapshots()
        .map(_docSnapshotToFriends);
  }

  List<String> _docSnapshotToFriends(DocumentSnapshot doc) {
    List<String> friends = [];

    if (doc.data['friends'] == null) {
      return List<String>();
    }

    Map<String, bool> friendData = Map<String, bool>.from(doc.data['friends']);

    if (friendData == null) {
      return friends;
    }

    friendData.forEach((key, value) {
      friends.add(key);
    });

    return friends;
  }

  Future<bool> addFriend(String displayName) async {
    try {
      await _userCollection.document(_upperCaseName).setData(
        {
          'friends': {
            displayName: true,
          }
        },
        merge: true,
      );

      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> removeFriend(String displayName) async {
    try {
      await _userCollection.document(_upperCaseName).updateData({
        'friends.$displayName': FieldValue.delete(),
      });
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> addDisplayNameField() async {
    try {
      await _userCollection.document(_upperCaseName).setData(
        {
          'display_name': _displayName,
        },
        merge: true,
      );
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> userExists() async {
    final snapshot = await _userCollection.document(_upperCaseName).get();
    if (snapshot == null || !snapshot.exists) {
      return false;
    }
    return true;
  }

  Future<List<DocumentSnapshot>> getUsersContainingQuery(String query) async {
    final snapshot = await _userCollection.getDocuments();
    final List<DocumentSnapshot> users = [];
    final String upperCaseQuery = query.toUpperCase();

    for (DocumentSnapshot doc in snapshot.documents) {
      if (doc.documentID.contains(upperCaseQuery)) {
        users.add(doc);
      }
    }

    return users;
  }
}
