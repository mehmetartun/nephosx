part of 'gpu_clusters_cubit.dart';

@immutable
sealed class GpuClustersState {}

final class GpuClustersInitial extends GpuClustersState {}

final class GpuClustersLoaded extends GpuClustersState {
  final List<GpuCluster> gpuClusters;
  GpuClustersLoaded({required this.gpuClusters});
}

final class GpuClustersError extends GpuClustersState {
  final String message;
  GpuClustersError({required this.message});
}

final class GpuClustersLoading extends GpuClustersState {}

final class GpuClustersAddEdit extends GpuClustersState {
  final GpuCluster? gpuCluster;
  final List<Datacenter> datacenters;
  GpuClustersAddEdit({this.gpuCluster, required this.datacenters});
}
