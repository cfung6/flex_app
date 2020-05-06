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
        .map(snapshotToSneakerList);
  }

  List<Sneaker> getSneakerCollectionFromDoc(DocumentSnapshot doc) {
    return snapshotToSneakerList(doc);
  }

  //DocumentSnapshot returns in the form of:
  //{
  //  sneakers: {...},
  //  otherProperty: {...},
  //}
  List<Sneaker> snapshotToSneakerList(DocumentSnapshot doc) {
    //sneakerData is in the form of:
    //{
    //  "jordan 1": {...},
    //  "jordan 4": {...},
    //}
    Map<String, dynamic> sneakerData =
    Map<String, dynamic>.from(doc.data['sneakers']);
    List<Sneaker> sneakerList = [];

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
          'display_name': _displayName,
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
