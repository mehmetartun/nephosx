import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:nephosx/model/gpu_cluster.dart';

import '../../../model/company.dart';
import '../../../model/datacenter.dart';
import '../../../model/gpu_transaction.dart';
import '../../../model/listing.dart';
import '../../../model/user.dart';
import '../../../repositories/database/database.dart';
import 'dart:math' as math;

part 'gpu_clusters_state.dart';

class GpuClustersCubit extends Cubit<GpuClustersState> {
  GpuClustersCubit(this.databaseRepository, {this.user})
    : super(GpuClustersInitial());
  final User? user;
  final DatabaseRepository databaseRepository;
  List<Datacenter> datacenters = [];
  StreamSubscription<List<GpuCluster>>? gpuClustersSubscription;
  StreamSubscription<List<GpuTransaction>>? transactionsSubscription;
  StreamSubscription<List<Listing>>? listingsSubscription;
  List<GpuCluster> gpuClusters = [];
  List<GpuTransaction> transactions = [];
  List<Company> companies = [];
  List<Listing> listings = [];
  HttpsCallable gpuClusterUpdateCheck = FirebaseFunctions.instance
      .httpsCallable("gpuCluster-gpuClusterUpdateCheck");

  void init({String? gpuClusterId}) async {
    emit(GpuClustersInitial());

    gpuClustersSubscription ??= databaseRepository
        .gpuClustersStream(companyId: user?.companyId)
        .listen((e) {
          gpuClusters = e;
        });
    // gpuClustersSubscription?.cancel();
    if (user == null) {
      emit(GpuClustersError(message: "User not found"));
      return;
    }

    // gpuClustersSubscription = databaseRepository
    //     .getGpuClusterStream(companyId: user?.companyId)
    //     .listen((gpuClusters) {
    //       this.gpuClusters = gpuClusters;
    //       if (state is GpuClustersLoaded || state is GpuClustersInitial) {
    //         emit(GpuClustersLoaded(gpuClusters: gpuClusters));
    //       }
    //     });

    // companies = await databaseRepository.getCompanies();
    // datacenters = await databaseRepository.getDatacenters(
    //   companyId: user!.companyId,
    // );
    transactions = await databaseRepository.getGpuTransactions(
      companyId: user!.companyId,
    );
    listings = await databaseRepository.getListings(
      companyId: user!.companyId,
      status: ListingStatus.active,
    );
    gpuClusters = await databaseRepository.getGpuClusters(
      companyId: user!.companyId,
    );

    for (var gpuCluster in gpuClusters) {
      gpuCluster.addListings(listings);
      gpuCluster.addTransactions(transactions);
    }

    if (gpuClusterId != null) {
      GpuCluster? gpuCluster = gpuClusters.firstWhereOrNull(
        (element) => element.id == gpuClusterId,
      );
      if (gpuCluster != null) {
        emit(GpuClusterDetail(gpuCluster: gpuCluster));
        return;
      }
    }

    emit(GpuClustersLoaded(gpuClusters: gpuClusters));
  }

  void cancelAddGpuCluster() {
    init();
  }

  void gpuClusterDetailRequest(GpuCluster gpuCluster) {
    emit(GpuClustersLoading());
    init(gpuClusterId: gpuCluster.id);
  }

  void showGpuClusters() {
    emit(GpuClustersLoaded(gpuClusters: gpuClusters));
  }

  void addGpuCluster(GpuCluster gpuCluster) {
    emit(GpuClustersLoading());
    Datacenter? dt = datacenters.firstWhereOrNull(
      (element) => element.id == gpuCluster.datacenterId,
    );

    databaseRepository.addDocument(
      collectionPath: "datacenters/${gpuCluster.datacenterId}/gpu_clusters",
      data: {
        ...gpuCluster.toJson(),
        "company_id": user!.companyId,
        "datacenter": dt?.toJson(),
        "company": user?.company?.toJson(),
      },
    );
    init();
  }

  void updateGpuCluster(GpuCluster gpuCluster) {
    emit(GpuClustersLoading());
    databaseRepository.updateDocument(
      docPath:
          "datacenters/${gpuCluster.datacenterId}/gpu_clusters/${gpuCluster.id}",
      data: gpuCluster.toJson(),
    );
    init();
  }

  void addGpuClusterRequest() {
    emit(GpuClustersAddEdit(gpuCluster: null, datacenters: datacenters));
  }

  void updateGpuClusterRequest(GpuCluster gpuCluster) async {
    emit(GpuClustersLoading());
    HttpsCallableResult result = await gpuClusterUpdateCheck.call({
      'gpuClusterId': gpuCluster.id,
    });
    if (result.data['update_possible'] == true) {
      emit(
        GpuClustersAddEdit(gpuCluster: gpuCluster, datacenters: datacenters),
      );
    } else {
      emit(GpuClustersError(message: "Update not possible"));
    }
  }

  @override
  Future<void> close() async {
    gpuClustersSubscription?.cancel();
    return super.close();
  }
}
