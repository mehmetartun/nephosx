part of 'transactions_bloc.dart';

sealed class TransactionsEvent {}

class TransactionsEventStart extends TransactionsEvent {
  final User user;

  TransactionsEventStart({required this.user});
}
