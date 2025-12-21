import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/gpu_cluster.dart';
import '../../model/gpu_transaction.dart';
import '../../model/listing.dart';
import '../../model/user.dart';
import '../../repositories/database/database.dart';

part 'data_event.dart';
part 'data_state.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  DataBloc({required this.databaseRepository}) : super(DataInitial()) {
    // on<DataEvent>((event, emit) {});
    on<DataStartEvent>((event, emit) async {
      await _onDataStartEvent(event, emit);
    });
    on<DataStopEvent>(_onDataStopEvent);
    on<DataRefreshEvent>(_onDataRefreshEvent);
  }

  StreamSubscription<List<GpuTransaction>>? transactionsSubscription;
  StreamSubscription<List<GpuCluster>>? gpuClustersSubscription;
  StreamSubscription<List<Listing>>? listingsSubscription;
  StreamSubscription<List<User>>? usersSubscription;

  List<GpuTransaction> transactions = [];
  List<GpuCluster> gpuClusters = [];
  List<Listing> listings = [];
  List<User> corporateUsers = [];

  final DatabaseRepository databaseRepository;
  User? user;

  void _onDataRefreshEvent(
    DataRefreshEvent event,
    Emitter<DataState> emit,
  ) async {
    if (user == null) add(DataStopEvent());
    emit(
      DataLoaded(
        transactions: transactions,
        gpuClusters: gpuClusters,
        listings: listings,
        corporateUsers: corporateUsers,
        user: user!,
      ),
    );
  }

  Future<void> _onDataStartEvent(
    DataStartEvent event,
    Emitter<DataState> emit,
  ) async {
    emit(DataLoading());
    await transactionsSubscription?.cancel();
    await gpuClustersSubscription?.cancel();
    await listingsSubscription?.cancel();
    await usersSubscription?.cancel();
    transactions = [];
    gpuClusters = [];
    listings = [];
    corporateUsers = [];
    user = event.user;
    if (user == null || user!.companyId == null) {
      emit(
        DataLoaded(
          transactions: transactions,
          gpuClusters: gpuClusters,
          listings: listings,
          corporateUsers: corporateUsers,
          user: user!,
        ),
      );
      return;
    }
    transactionsSubscription = databaseRepository
        .gpuTransactionsStream(companyId: user!.companyId!)
        .listen((transactions) {
          this.transactions = transactions;
          print("Got Transactions: ${transactions.length}");
          add(DataRefreshEvent());
        });
    gpuClustersSubscription = databaseRepository
        .gpuClustersStream(companyId: user!.companyId!)
        .listen((gpuClusters) {
          this.gpuClusters = gpuClusters;
          print("Got GpuClusters: ${gpuClusters.length}");
          add(DataRefreshEvent());
        });
    listingsSubscription = databaseRepository
        .listingsStream(companyId: user!.companyId!)
        .listen((listings) {
          this.listings = listings;
          print("Got Listings: ${listings.length}");
          add(DataRefreshEvent());
        });
    usersSubscription = databaseRepository
        .usersStream(companyId: user!.companyId!)
        .listen((users) {
          corporateUsers = users;
          print("Got Users: ${users.length}");
          add(DataRefreshEvent());
        });
  }

  Future<void> _onDataStopEvent(
    DataStopEvent event,
    Emitter<DataState> emit,
  ) async {
    await transactionsSubscription?.cancel();
    await gpuClustersSubscription?.cancel();
    await listingsSubscription?.cancel();
    await usersSubscription?.cancel();
    transactions = [];
    gpuClusters = [];
    listings = [];
    corporateUsers = [];
    user = null;
    emit(DataInitial());
  }

  @override
  Future<void> close() async {
    await transactionsSubscription?.cancel();
    await gpuClustersSubscription?.cancel();
    await listingsSubscription?.cancel();
    await usersSubscription?.cancel();
    return super.close();
  }
}
