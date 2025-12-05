import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  void init() async {
    emit(GpuClustersLoading());

    var qs = await FirebaseFirestore.instance
        .collectionGroup('gpu_clusters')
        .get();
    for (var doc in qs.docs) {
      doc.reference.update({'pcie_generation': 'x5'});
    }
    //   //   "per_gpu_vram_in_gb": (20 + math.Random().nextDouble() * 100).floor(),
    //   //   "per_gpu_memory_bandwidth_in_gb_per_sec":
    //   //       ((3 + math.Random().nextDouble() * 3) * 100).floor() / 100,
    //   //   "per_gpu_nv_link_bandwidth_in_gb_per_sec":
    //   //       ((2 + math.Random().nextDouble() * 2) * 100).floor() / 100,
    //   //   "tera_flops":
    //   //       ((20 + math.Random().nextDouble() * 2) * 100).floor() / 100,
    //   //   "effective_ram":
    //   //       ((20 + math.Random().nextDouble() * 100) * 100).floor() / 100,
    //   //   "total_ram":
    //   //       ((20 + math.Random().nextDouble() * 100) * 100).floor() / 100,
    //   //   "total_cpu_core_count":
    //   //       ((20 + math.Random().nextDouble() * 100) * 100).floor() / 100,
    //   //   "effective_cpu_core_count":
    //   //       ((20 + math.Random().nextDouble() * 100) * 100).floor() / 100,
    //   //   "internet_upload_speed_in_mbps":
    //   //       ((20 + math.Random().nextDouble() * 100) * 100).floor() / 100,
    //   //   "internet_download_speed_in_mbps":
    //   //       ((20 + math.Random().nextDouble() * 100) * 100).floor() / 100,
    //   //   "number_of_open_ports":
    //   //       ((20 + math.Random().nextDouble() * 100) * 100).floor() / 100,
    //   //   "disk_bandwidth_in_mb_per_sec":
    //   //       ((20 + math.Random().nextDouble() * 100) * 100).floor() / 100,
    //   //   "disk_storage_available_in_gb":
    //   //       ((20 + math.Random().nextDouble() * 100) * 100).floor() / 100,
    //   //   "deep_learning_performance_score":
    //   //       ((20 + math.Random().nextDouble() * 100) * 100).floor() / 100,
    //   //   "pcie_generation": "PCIe 5.0",
    //   //   "pcie_lanes":
    //   //       ((20 + math.Random().nextDouble() * 100) * 100).floor() / 100,
    //   //   "per_gpu_pcie_bandwidth_in_gb_per_sec":
    //   //       ((20 + math.Random().nextDouble() * 100) * 100).floor() / 100,
    //   //   "maximum_cuda_version_supported": "CUDA 12.0",
    //   // });
    //   // await doc.reference.update({
    //   //   'rental_prices': [
    //   //     {
    //   //       "number_of_months": 1,
    //   //       "price_in_usd_per_hour":
    //   //           ((3 + math.Random().nextDouble() * 3) * 100).floor() / 100,
    //   //     },
    //   //     {
    //   //       "number_of_months": 3,
    //   //       "price_in_usd_per_hour":
    //   //           ((3 + math.Random().nextDouble() * 3) * 100).floor() / 100,
    //   //     },
    //   //     {
    //   //       "number_of_months": 6,
    //   //       "price_in_usd_per_hour":
    //   //           ((3 + math.Random().nextDouble() * 3) * 100).floor() / 100,
    //   //     },
    //   //     {
    //   //       "number_of_months": 12,
    //   //       "price_in_usd_per_hour":
    //   //           ((3 + math.Random().nextDouble() * 3) * 100).floor() / 100,
    //   //     },
    //   //   ],
    //   // });

    gpuClustersSubscription?.cancel();
    if (user == null) {
      emit(GpuClustersError(message: "User not found"));
      return;
    }
    gpuClustersSubscription = databaseRepository
        .getGpuClusterStream(companyId: user?.companyId)
        .listen((gpuClusters) {
          this.gpuClusters = gpuClusters;
          emit(GpuClustersLoaded(gpuClusters: gpuClusters));
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

  void updateGpuClusterRequest(GpuCluster gpuCluster) {
    emit(GpuClustersAddEdit(gpuCluster: gpuCluster, datacenters: datacenters));
  }

  @override
  Future<void> close() async {
    gpuClustersSubscription?.cancel();
    return super.close();
  }
}
