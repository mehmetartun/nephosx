import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/consumption.dart';
import '../../model/drink.dart';
import '../../model/drink_image.dart';
import '../../model/drinking_note.dart';
import '../../model/user.dart';

class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);

  @override
  String toString() => "DatabaseException: $message";
}

abstract class DatabaseRepository {
  Future<User> getUserData(String uid);
  Future<void> saveUserData(Map<String, dynamic> userData);
  Future<void> updateUserData(Map<String, dynamic> userData);
  Future<void> saveImageData({
    required String fileName,
    required String base64String,
  });
  Future<Drink> getDrink(String drinkId);
  Future<List<Drink>> getDrinks();
  Future<List<DrinkImage>> getDrinkImages();
  Future<void> updateDocument({
    required String docPath,
    required Map<String, dynamic> data,
  });
  Future<Map<String, dynamic>> addDocument({
    required String collectionPath,
    required Map<String, dynamic> data,
  });
  Future<void> delete({required String path});

  Stream<List<Drink>> getDrinkStream();
  Stream<List<Consumption>> getConsumptionStream(String uid);
  Stream<List<DrinkingNote>> getDrinkingNoteStream(String uid);
}

class FirestoreDatabaseRepository extends DatabaseRepository {
  static final FirestoreDatabaseRepository instance =
      FirestoreDatabaseRepository._internal();

  late final FirebaseFirestore db;

  FirestoreDatabaseRepository._internal() {
    db = FirebaseFirestore.instance;

    db.settings = Settings(persistenceEnabled: true);
  }

  @override
  Stream<List<Drink>> getDrinkStream() {
    return db.collection('drinks').snapshots().map<List<Drink>>((snapshot) {
      return snapshot.docs.map((doc) {
        return Drink.fromJson({...doc.data(), 'id': doc.id});
      }).toList();
    });
  }

  @override
  Stream<List<Consumption>> getConsumptionStream(String uid) {
    return db.collection('users/$uid/diary').snapshots().map<List<Consumption>>(
      (snapshot) {
        return snapshot.docs.map((doc) {
          return Consumption.fromJson({...doc.data(), 'id': doc.id});
        }).toList();
      },
    );
  }

  @override
  Stream<List<DrinkingNote>> getDrinkingNoteStream(String uid) {
    return db
        .collection('users/$uid/notes')
        .snapshots()
        .map<List<DrinkingNote>>((snapshot) {
          return snapshot.docs.map((doc) {
            return DrinkingNote.fromJson({...doc.data(), 'id': doc.id});
          }).toList();
        });
  }

  @override
  Future<void> delete({required String path}) async {
    await db.doc(path).delete();
  }

  @override
  Future<void> updateDocument({
    required String docPath,
    required Map<String, dynamic> data,
  }) async {
    await db.doc(docPath).update(data);
  }

  @override
  Future<Map<String, dynamic>> addDocument({
    required String collectionPath,
    required Map<String, dynamic> data,
  }) async {
    var ref = await db.collection(collectionPath).add(data);
    return {'id': ref.id, 'path': ref.path};
  }

  @override
  Future<void> saveImageData({
    required String fileName,
    required String base64String,
  }) async {
    await FirebaseFirestore.instance.collection('images').add({
      'fileName': fileName,
      'base64': base64String,
      'timestamp': FieldValue.serverTimestamp(), // Optional: add a timestamp
    });
  }

  @override
  Future<Drink> getDrink(String drinkId) async {
    var qs = await db.collection("drinks").doc(drinkId).get();
    return Drink.fromJson({...qs.data()!, 'id': drinkId});
  }

  @override
  Future<List<Drink>> getDrinks() async {
    var qs = await db.collection("drinks").get();
    return qs.docs
        .map((doc) => Drink.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  @override
  Future<List<DrinkImage>> getDrinkImages() async {
    var qs = await db.collection("images").get();
    return qs.docs
        .where((doc) {
          return doc.data()['used'] != true;
        })
        .toList()
        .map(
          (doc) => DrinkImage(
            fileName: doc['fileName'],
            imageBase64: doc['base64'],
            id: doc.id,
          ),
        )
        .toList();
  }

  @override
  Future<User> getUserData(String uid) async {
    // Implementation to get user data from Firestore
    // Placeholder implementation
    DocumentSnapshot userDocument = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    if (userDocument.exists) {
      final data = userDocument.data() as Map<String, dynamic>;
      return User.fromMap(data);
    } else {
      throw DatabaseException("User not found");
    }
  }

  @override
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userData['uid'])
        .set(userData, SetOptions(merge: true));
  }

  @override
  Future<void> updateUserData(Map<String, dynamic> userData) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userData['uid'])
        .update(userData);
  }
}
