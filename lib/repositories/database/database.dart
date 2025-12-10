import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nephosx/model/gpu_transaction.dart';
import 'package:nephosx/model/request.dart';

import '../../model/company.dart';
import '../../model/cpu.dart';
import '../../model/datacenter.dart';
import '../../model/device.dart';

import '../../model/enums.dart';
import '../../model/gpu_cluster.dart';
import '../../model/platform_settings.dart';
import '../../model/producer.dart';
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

  Future<void> updateDocument({
    required String docPath,
    required Map<String, dynamic> data,
  });
  Future<Map<String, dynamic>> addDocument({
    required String collectionPath,
    required Map<String, dynamic> data,
  });
  Future<void> delete({required String path});

  Stream<User?> getUserStream(String uid);

  Stream<List<GpuCluster>> getGpuClusterStream({String? companyId});
  Stream<List<User>> getUsersStream();
  Future<List<User>> getUsers({String? companyId});
  Future<List<Company>> getCompanies();
  Future<List<Datacenter>> getDatacenters({String? companyId});
  Future<List<GpuCluster>> getGpuClusters({String? companyId});
  Future<Company> getCompany(String companyId);

  Future<List<Request>> getRequestsByRequestorId(String requestorId);
  Future<List<Request>> getRequestsByCompanyId(String companyId);
  Future<List<Request>> getRequests();

  Stream<List<Request>> getRequestsByCompanyIdStream(String companyId);
  Stream<List<Request>> getRequestsByRequestorIdStream(String requestorId);

  Stream<List<GpuTransaction>> getGpuTransactionStream({
    String? companyId,
    TransactionType? type,
  });
  Future<PlatformSettings> getPlatformSettings();
}

class FirestoreDatabaseRepository extends DatabaseRepository {
  static final FirestoreDatabaseRepository instance =
      FirestoreDatabaseRepository._internal();

  final FirebaseFirestore db = FirebaseFirestore.instance;

  FirestoreDatabaseRepository._internal() {
    db.settings = Settings(persistenceEnabled: true);
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

  @override
  Stream<List<GpuCluster>> getGpuClusterStream({String? companyId}) {
    return db
        .collectionGroup("gpu_clusters")
        .where("company_id", isEqualTo: companyId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => GpuCluster.fromJson({...doc.data(), 'id': doc.id}))
              .toList();
        });
  }

  @override
  Stream<List<GpuTransaction>> getGpuTransactionStream({
    String? companyId,
    TransactionType? type,
  }) {
    return db.collection("transactions").snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => GpuTransaction.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    });
  }

  @override
  Future<PlatformSettings> getPlatformSettings() async {
    var futs = <Future<dynamic>>[];

    futs.add(getSettings());
    futs.add(getProducers());
    futs.add(getDevices());
    futs.add(getCpus());

    var results = await Future.wait(futs);

    return PlatformSettings.fromJson({
      ...results[0],
      'producers': results[1].map((e) => e.toJson()).toList(),
      'devices': results[2].map((e) => e.toJson()).toList(),
      'cpus': results[3].map((e) => e.toJson()).toList(),
    });
  }

  Future<Map<String, dynamic>> getSettings() async {
    var settings_query = await db.doc("settings/settings").get();
    if (settings_query.exists) {
      return settings_query.data()!;
    } else {
      return PlatformSettings.defaultSettings.toJson();
    }
  }

  Future<List<Producer>> getProducers() async {
    var producers_query = await db
        .collection("settings/settings/producers")
        .get();
    return producers_query.docs
        .map((doc) => Producer.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  Future<List<Device>> getDevices() async {
    var devices_query = await db.collection("settings/settings/devices").get();
    return devices_query.docs
        .map((doc) => Device.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  Future<List<Cpu>> getCpus() async {
    var cpus_query = await db.collection("settings/settings/cpus").get();
    return cpus_query.docs
        .map((doc) => Cpu.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  @override
  Future<List<Request>> getRequests() async {
    var qs = await db.collectionGroup("requests").get();
    return qs.docs.map((doc) => Request.fromJson({...doc.data()})).toList();
  }
}
