part of 'data_bloc.dart';

sealed class DataState {}

final class DataInitial extends DataState {}

final class DataLoaded extends DataState {
  final User user;
  final List<User> corporateUsers;
  final List<GpuTransaction> transactions;
  final List<GpuCluster> gpuClusters;
  final List<Listing> listings;
  final List<Company> companies;

  DataLoaded({
    required this.user,
    required this.corporateUsers,
    required this.transactions,
    required this.gpuClusters,
    required this.listings,
    required this.companies,
  });
}

final class DataLoading extends DataState {}

final class DataError extends DataState {
  final String message;

  DataError(this.message);
}
