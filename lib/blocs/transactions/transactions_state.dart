part of 'transactions_bloc.dart';

sealed class TransactionsState {}

final class TransactionsStateInitial extends TransactionsState {}

final class TransactionsStateNotAuthorised extends TransactionsState {}

final class TransactionsStateLoaded extends TransactionsState {
  final List<GpuTransaction> transactions;

  TransactionsStateLoaded({required this.transactions});
}
