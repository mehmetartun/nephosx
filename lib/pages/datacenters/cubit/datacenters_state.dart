part of 'datacenters_cubit.dart';

sealed class DatacentersState {}

final class DatacentersInitial extends DatacentersState {}

final class DatacentersLoaded extends DatacentersState {
  final List<Datacenter> datacenters;
  DatacentersLoaded({required this.datacenters});
}

final class DatacentersErrorState extends DatacentersState {
  final String message;
  DatacentersErrorState({required this.message});
}

final class DatacentersGpus extends DatacentersState {
  final List<Gpu> gpus;
  final Datacenter datacenter;
  DatacentersGpus({required this.gpus, required this.datacenter});
}
