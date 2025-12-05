import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nephosx/model/request.dart';

import '../../model/company.dart';
import '../../model/consumption.dart';
import '../../model/datacenter.dart';
import '../../model/drink.dart';
import '../../model/drink_image.dart';
import '../../model/drinking_note.dart';
import '../../model/gpu_cluster.dart';
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
  Stream<User?> getUserStream(String uid);

  Stream<List<User>> getUsersStream();
  Future<List<User>> getUsers({String? companyId});
  Future<List<Company>> getCompanies();
  Future<List<Datacenter>> getDatacenters({String? companyId});
  Future<List<GpuCluster>> getGpuClusters({String? companyId});
  Future<Company> getCompany(String companyId);
  Future<List<Request>> getRequestsByRequestorId(String requestorId);
  Future<List<Request>> getRequestsByCompanyId(String companyId);
  Stream<List<Request>> getRequestsByCompanyIdStream(String companyId);
  Stream<List<Request>> getRequestsByRequestorIdStream(String requestorId);
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
    await ref.update({'id': ref.id});
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
      // if ((userDocument.data() as Map<String, dynamic>)['company_id'] != null) {
      //   var companyDocument = await db
      //       .collection('companies')
      //       .doc((userDocument.data() as Map<String, dynamic>)['company_id'])
      //       .get();
      //   if (companyDocument.exists) {
      //     Company company = Company.fromJson({
      //       ...companyDocument.data()!,
      //       'id': companyDocument.id,
      //     });
      //     final data = userDocument.data() as Map<String, dynamic>;
      //     return User.fromJson(data).copyWith(company: company);
      //   }
      // }
      final data = userDocument.data() as Map<String, dynamic>;
      print(data);
      return User.fromJson(userDocument.data() as Map<String, dynamic>);
    } else {
      throw DatabaseException("User has not been found");
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

  @override
  Stream<List<User>> getUsersStream() {
    return db.collection('users').snapshots().map<List<User>>((snapshot) {
      return snapshot.docs.map((doc) {
        return User.fromJson(doc.data());
      }).toList();
    });
  }

  @override
  Future<List<User>> getUsers({String? companyId}) async {
    if (companyId != null) {
      var qs = await db
          .collection("users")
          .where("company_id", isEqualTo: companyId)
          .get();
      return qs.docs.map((doc) => User.fromJson(doc.data())).toList();
    } else {
      var qs = await db.collection("users").get();
      return qs.docs.map((doc) => User.fromJson(doc.data())).toList();
    }
  }

  @override
  Future<List<Company>> getCompanies() async {
    var qs = await db.collection("companies").get();
    return qs.docs
        .map((doc) => Company.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  @override
  Future<List<Datacenter>> getDatacenters({String? companyId}) async {
    QuerySnapshot<Map<String, dynamic>> qs;
    if (companyId != null) {
      qs = await db
          .collection("datacenters")
          .where('company_id', isEqualTo: companyId)
          .get();
    } else {
      qs = await db.collection("datacenters").get();
    }
    print("Getting Datacenters");
    return qs.docs
        .map<Datacenter>(
          (doc) => Datacenter.fromJson({...doc.data(), 'id': doc.id}),
        )
        .toList();
  }

  @override
  Stream<User?> getUserStream(String uid) {
    return db
        .collection('users')
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map<User?>((snapshot) {
          return snapshot.docs
              .map((doc) {
                return User.fromJson(doc.data());
              })
              .toList()
              .firstOrNull;
        });
  }

  @override
  Future<List<GpuCluster>> getGpuClusters({String? companyId}) async {
    QuerySnapshot<Map<String, dynamic>> qs;
    if (companyId != null) {
      qs = await db
          .collectionGroup("gpu_clusters")
          .where('company_id', isEqualTo: companyId)
          .get();
    } else {
      qs = await db.collectionGroup("gpu_clusters").get();
    }
    return qs.docs
        .map((doc) => GpuCluster.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  @override
  Future<Company> getCompany(String companyId) async {
    var qs = await db.collection("companies").doc(companyId).get();
    return Company.fromJson({...qs.data()!, 'id': companyId});
  }

  @override
  Future<List<Request>> getRequestsByCompanyId(String companyId) async {
    var qs = await db
        .collectionGroup("requests")
        .where("company_id", isEqualTo: companyId)
        .get();
    return qs.docs.map((doc) => Request.fromJson(doc.data())).toList();
  }

  @override
  Future<List<Request>> getRequestsByRequestorId(String requestorId) async {
    var qs = await db
        .collectionGroup("requests")
        .where("requestor_id", isEqualTo: requestorId)
        .get();
    return qs.docs.map((doc) => Request.fromJson({...doc.data()})).toList();
  }

  @override
  Stream<List<Request>> getRequestsByCompanyIdStream(String companyId) {
    return db
        .collectionGroup("requests")
        .where("target_company_id", isEqualTo: companyId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Request.fromJson(doc.data()))
              .toList();
        });
  }

  @override
  Stream<List<Request>> getRequestsByRequestorIdStream(String requestorId) {
    return db
        .collectionGroup("requests")
        .where("requestor_id", isEqualTo: requestorId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Request.fromJson(doc.data()))
              .toList();
        });
  }
}
