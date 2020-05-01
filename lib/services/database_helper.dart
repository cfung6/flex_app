import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flex/models/sneaker.dart';

class DatabaseHelper {
  final CollectionReference userCollection =
      Firestore.instance.collection('users');
  final String displayName;

  DatabaseHelper({this.displayName});

  Stream<List<Sneaker>> getSneakerCollection() {
    return userCollection.document(displayName).snapshots().map((doc) {
      return doc.data['sneakers'].forEach((key, value) {
        return Sneaker.fromMap(key, value);
      });
    });
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
