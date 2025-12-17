import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/gpu_transaction.dart';
import '../../model/user.dart';
import '../../repositories/database/database.dart';

part 'transactions_event.dart';
part 'transactions_state.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  TransactionsBloc({required this.databaseRepository})
    : super(TransactionsStateInitial()) {
    on<TransactionsEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<TransactionsEventStart>((event, emit) async {
      await _handleStart(event, emit);
    });
  }

  final DatabaseRepository databaseRepository;
  StreamSubscription<List<GpuTransaction>>? transactionSubscription;

  Future<void> _handleStart(TransactionsEventStart event, Emitter emit) async {
    if (event.user.companyId == null) {
      emit(TransactionsStateNotAuthorised());
      return;
    }
    databaseRepository
        .gpuTransactionsStream(companyId: event.user.companyId!)
        .listen((transactions) {
          emit(TransactionsStateLoaded(transactions: transactions));
        });
  }

  @override
  Future<void> close() {
    transactionSubscription?.cancel();
    return super.close();
  }
}
