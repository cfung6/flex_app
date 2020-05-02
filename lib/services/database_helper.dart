import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flex/models/sneaker.dart';

class DatabaseHelper {
  final CollectionReference userCollection =
      Firestore.instance.collection('users');
  final String displayName;

  DatabaseHelper({this.displayName});

  Stream<List<Sneaker>> getSneakerCollection() {
    return userCollection
        .document(displayName)
        .snapshots()
        .map(snapshotToSneakerList);
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

  Future<void> addSneakerToCollection(Sneaker sneaker) async {
    return await userCollection.document(displayName).setData(
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
  }
}
