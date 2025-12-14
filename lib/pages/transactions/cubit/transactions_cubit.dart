import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nephosx/model/gpu_cluster.dart';
import 'package:rxdart/rxdart.dart';

import '../../../model/company.dart';
import '../../../model/datacenter.dart';
import '../../../model/enums.dart';
import '../../../model/gpu_transaction.dart';
import '../../../model/user.dart';
import '../../../repositories/database/database.dart';
import '../../../services/csv/csv_service.dart';

part 'transactions_state.dart';

class TransactionsCubit extends Cubit<TransactionsState> {
  TransactionsCubit(this.databaseRepository, this.user)
    : super(TransactionsInitial());
  final DatabaseRepository databaseRepository;
  StreamSubscription<List<GpuTransaction>>? _transactionsSubscription;
  final User? user;

  List<GpuTransaction> transactions = [];
  List<Company> companies = [];
  List<GpuCluster> gpuClusters = [];
  List<Datacenter> datacenters = [];

  void init() async {
    if (user == null) {
      emit(TransactionErrorState(message: "User cannot be null"));
    }
    _transactionsSubscription?.cancel();
    companies = await databaseRepository.getCompanies();
    gpuClusters = await databaseRepository.getGpuClusters();
    datacenters = await databaseRepository.getDatacenters();

    // _transactionsSubscription =
    //     Rx.combineLatest2(
    //       databaseRepository.getGpuTransactionStream(
    //         type: TransactionType.buy,
    //         companyId: user!.companyId,
    //       ),
    //       databaseRepository.getGpuTransactionStream(
    //         type: TransactionType.buy,
    //         companyId: user!.companyId,
    //       ),
    //       (streamA, streamB) {
    //         return streamA + streamB;
    //       },
    //     ).listen((s) {
    //       transactions = s;
    //       emit(
    //         TransactionsLoaded(
    //           transactions: transactions,
    //           companies: companies,
    //           gpuClusters: gpuClusters,
    //         ),
    //       );
    //     });

    _transactionsSubscription = databaseRepository
        .getGpuTransactionStream(companyId: user!.companyId!)
        .listen((transactions) {
          this.transactions = transactions;
          for (GpuTransaction tx in this.transactions) {
            tx.addBuyer(companies);
            tx.addSeller(companies);
            tx.addGpuCluster(gpuClusters);
            tx.addDatacenter(datacenters);
          }
          emit(
            TransactionsLoaded(
              transactions: transactions,
              companies: companies,
              gpuClusters: gpuClusters,
            ),
          );
        });
    // transactions = await databaseRepository.getTransactions();
    // emit(
    //   TransactionsLoaded(
    //     transactions: transactions,
    //     companies: companies,
    //     gpuClusters: gpuClusters,
    //   ),
    // );
  }

  @override
  Future<void> close() {
    _transactionsSubscription?.cancel();
    return super.close();
  }

  void onExport() {
    CsvService().exportTransactions(transactions);
  }
}
