part of 'datacenters_cubit.dart';

sealed class DatacentersState {}

final class DatacentersInitial extends DatacentersState {}

final class DatacentersLoaded extends DatacentersState {
  final List<Datacenter> datacenters;
  final List<Company> companies;
  DatacentersLoaded({required this.datacenters, required this.companies});
}

final class DatacentersErrorState extends DatacentersState {
  final String message;
  DatacentersErrorState({required this.message});
}

final class DatacentersGpuClusters extends DatacentersState {
  final List<GpuCluster> gpuClusters;
  final Datacenter datacenter;
  final List<Company> companies;
  DatacentersGpuClusters({
    required this.gpuClusters,
    required this.datacenter,
    required this.companies,
  });
}
