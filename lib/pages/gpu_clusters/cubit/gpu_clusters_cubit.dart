import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:nephosx/model/gpu_cluster.dart';

import '../../../model/datacenter.dart';
import '../../../model/user.dart';
import '../../../repositories/database/database.dart';

part 'gpu_clusters_state.dart';

class GpuClustersCubit extends Cubit<GpuClustersState> {
  GpuClustersCubit(this.databaseRepository, {this.user})
    : super(GpuClustersInitial());
  final User? user;
  final DatabaseRepository databaseRepository;
  List<Datacenter> datacenters = [];
  void init() async {
    emit(GpuClustersLoading());
    if (user == null) {
      emit(GpuClustersError(message: "User not found"));
      return;
    }
    datacenters = await databaseRepository.getDatacenters(
      companyId: user!.companyId,
    );
    final gpuClusters = await databaseRepository.getGpuClusters(
      companyId: user!.companyId,
    );
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

  void updateGpuClusterRequest(GpuCluster gpuCluster) {
    emit(GpuClustersAddEdit(gpuCluster: gpuCluster, datacenters: datacenters));
  }
}
