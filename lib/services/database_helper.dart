import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flex/models/sneaker.dart';
import 'package:flex/provider_models/follower_list.dart';
import 'package:flex/provider_models/follower_num.dart';
import 'package:flex/provider_models/following_list.dart';
import 'package:flex/provider_models/following_num.dart';

class DatabaseHelper {
  final CollectionReference _userCollection =
  Firestore.instance.collection('users');
  String _upperCaseName;
  String _currentUserDisplayName;

  //All display names are converted to upper case as document ids to ensure
  //uniqueness of display names ignoring capitalization
  DatabaseHelper(String displayName) {
    if (displayName != null) {
      _currentUserDisplayName = displayName;
      _upperCaseName = displayName.toUpperCase();
    }
  }

  Stream<List<Sneaker>> getSneakerCollection() {
    return _userCollection
        .document(_upperCaseName)
        .snapshots()
        .map(snapshotToSneakerList);
  }

  //DocumentSnapshot returns in the form of:
  //{
  //  sneakers: {...},
  //  otherProperty: {...},
  //}
  List<Sneaker> snapshotToSneakerList(DocumentSnapshot doc) {
    List<Sneaker> sneakerList = [];

    if (doc == null || doc.data == null || doc.data['sneakers'] == null) {
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

  Stream<FollowingList> getFollowing() {
    return _userCollection
        .document(_upperCaseName)
        .snapshots()
        .map(_docSnapshotToFollowing)
        .map((list) => FollowingList(list));
  }

  Stream<FollowerList> getFollowers() {
    return _userCollection
        .document(_upperCaseName)
        .snapshots()
        .map(_docSnapshotToFollowers)
        .map((list) => FollowerList(list));
  }

  List<String> _docSnapshotToFollowing(DocumentSnapshot doc) {
    List<String> following = [];

    if (doc.data['following'] == null) {
      return List<String>();
    }

    Map<String, bool> friendData =
    Map<String, bool>.from(doc.data['following']);

    if (friendData == null) {
      return following;
    }

    friendData.forEach((key, value) {
      following.add(key);
    });

    return following;
  }

  List<String> _docSnapshotToFollowers(DocumentSnapshot doc) {
    List<String> followers = [];

    if (doc.data['followers'] == null) {
      return List<String>();
    }

    Map<String, bool> friendData =
    Map<String, bool>.from(doc.data['followers']);

    if (friendData == null) {
      return followers;
    }

    friendData.forEach((key, value) {
      followers.add(key);
    });

    return followers;
  }

  Future<bool> follow(String displayName) async {
    try {
      await _userCollection.document(_upperCaseName).setData(
        {
          'following': {
            displayName: true,
          }
        },
        merge: true,
      );

      if (!(await incrementNumFollowing(_upperCaseName))) {
        return false;
      }

      await _userCollection.document(displayName.toUpperCase()).setData(
        {
          'followers': {
            _currentUserDisplayName: true,
          }
        },
        merge: true,
      );

      if (!(await incrementNumFollowers(displayName.toUpperCase()))) {
        return false;
      }

      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> unfollow(String displayName) async {
    try {
      await _userCollection.document(_upperCaseName).updateData({
        'following.$displayName': FieldValue.delete(),
      });

      if (!(await decrementNumFollowing(_upperCaseName))) {
        return false;
      }

      await _userCollection.document(displayName.toUpperCase()).updateData({
        'followers.$displayName': FieldValue.delete(),
      });

      if (!(await decrementNumFollowers(displayName.toUpperCase()))) {
        return false;
      }

      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Stream<FollowingNum> getNumFollowing() {
    return _userCollection.document(_upperCaseName).snapshots().map((doc) {
      if (doc['num_following'] == null) {
        return FollowingNum(0);
      } else {
        return FollowingNum(doc['num_following']);
      }
    });
  }

  Stream<FollowerNum> getNumFollowers() {
    return _userCollection.document(_upperCaseName).snapshots().map((doc) {
      if (doc['num_followers'] == null) {
        return FollowerNum(0);
      } else {
        return FollowerNum(doc['num_followers']);
      }
    });
  }

  Future<bool> incrementNumFollowing(String displayName) async {
    try {
      await _userCollection.document(displayName).setData(
        {
          'num_following': FieldValue.increment(1),
        },
        merge: true,
      );
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> decrementNumFollowing(String displayName) async {
    try {
      await _userCollection.document(displayName).setData(
        {
          'num_following': FieldValue.increment(-1),
        },
        merge: true,
      );
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> incrementNumFollowers(String displayName) async {
    try {
      await _userCollection.document(displayName).setData(
        {
          'num_followers': FieldValue.increment(1),
        },
        merge: true,
      );
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> decrementNumFollowers(String displayName) async {
    try {
      await _userCollection.document(displayName).setData(
        {
          'num_followers': FieldValue.increment(-1),
        },
        merge: true,
      );
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
          'display_name': _currentUserDisplayName,
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

  Stream<DocumentSnapshot> getDocumentFromDisplayName() {
    return _userCollection.document(_upperCaseName).snapshots();
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

  String getDisplayNameFromDoc(DocumentSnapshot doc) {
    if (doc == null || doc.data == null) {
      return '';
    }

    String name = doc.data['display_name'];

    if (name == null) {
      return '';
    }
    return name;
  }
}
