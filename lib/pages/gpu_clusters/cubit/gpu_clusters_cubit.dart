import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:nephosx/model/gpu_cluster.dart';

import '../../../model/datacenter.dart';
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
  List<GpuCluster> gpuClusters = [];

  HttpsCallable gpuClusterUpdateCheck = FirebaseFunctions.instance
      .httpsCallable("gpuClusterUpdateCheck");

  void init() async {
    emit(GpuClustersInitial());
    gpuClustersSubscription?.cancel();
    if (user == null) {
      emit(GpuClustersError(message: "User not found"));
      return;
    }
    gpuClustersSubscription = databaseRepository
        .getGpuClusterStream(companyId: user?.companyId)
        .listen((gpuClusters) {
          this.gpuClusters = gpuClusters;
          if (state is GpuClustersLoaded || state is GpuClustersInitial) {
            emit(GpuClustersLoaded(gpuClusters: gpuClusters));
          }
        });

    datacenters = await databaseRepository.getDatacenters(
      companyId: user!.companyId,
    );
    // final gpuClusters = await databaseRepository.getGpuClusters(
    //   companyId: user!.companyId,
    // );
    // emit(GpuClustersLoaded(gpuClusters: gpuClusters));
  }

  void cancelAddGpuCluster() {
    init();
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
