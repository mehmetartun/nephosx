part of 'transactions_cubit.dart';

sealed class TransactionsState {}

final class TransactionsInitial extends TransactionsState {}

final class TransactionsLoaded extends TransactionsState {
  final List<GpuTransaction> transactions;
  final List<Company> companies;
  final List<GpuCluster> gpuClusters;

  TransactionsLoaded({
    required this.transactions,
    required this.companies,
    required this.gpuClusters,
  });
}

final class TransactionErrorState extends TransactionsState {
  final String message;

  TransactionErrorState({required this.message});
}
