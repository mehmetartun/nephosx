import 'package:bloc/bloc.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:meta/meta.dart';

import '../../../model/datacenter.dart';
import '../../../model/gpu_cluster.dart';
import '../../../model/gpu_transaction.dart';
import '../../../model/listing.dart';
import '../../../model/rental_price.dart';
import '../../../model/user.dart';
import '../../../repositories/database/database.dart';

part 'market_state.dart';

class MarketCubit extends Cubit<MarketState> {
  MarketCubit(this.databaseRepository, this.user) : super(MarketInitial());
  final DatabaseRepository databaseRepository;
  final User? user;
  List<GpuCluster> gpuClusters = [];
  List<Listing> listings = [];
  List<Datacenter> datacenters = [];

  HttpsCallable addTransactionFunction = FirebaseFunctions.instance
      .httpsCallable('addTransaction');

  void init() async {
    emit(MarketLoading());
    try {
      gpuClusters = await databaseRepository.getGpuClusters();
      listings = await databaseRepository.getListings();
      datacenters = await databaseRepository.getDatacenters();

      for (var gpuCluster in gpuClusters) {
        gpuCluster.addListings(listings);
      }
      for (var listing in listings) {
        listing.addGpuCluster(gpuClusters);
        listing.addDatacenter(datacenters);
      }
      // emit(
      //   MarketLoaded(gpuClusters: gpuClusters, ownCompanyId: user?.companyId),
      // );
      emit(
        MarketLoadedListings(listings: listings, ownCompanyId: user?.companyId),
      );
    } catch (e) {
      emit(MarketError(message: "${e.toString()} Couldn't get GPU Clusters"));
    }
  }

  void addTransaction(GpuTransaction data) async {
    if (user == null) {
      return;
    }
    print(data.toJson());
    try {
      await addTransactionFunction.call(data.toJson());
      init();
    } on FirebaseFunctionsException catch (e) {
      print(e);
      emit(MarketError(message: e.toString()));
    } catch (e) {
      print(e);
      emit(MarketError(message: e.toString()));
    }
  }

  double priceCalculator(
    GpuCluster gpuCluster,
    DateTime fromDate,
    DateTime toDate,
  ) {
    final amount = RentalPrice.calculatePrice(
      gpuCluster.rentalPrices,
      fromDate,
      toDate,
    );
    return amount;
  }

  String? transactionValidator(
    GpuCluster gpuCluster,
    DateTime fromDate,
    DateTime toDate,
  ) {
    if (gpuCluster.transactions.isEmpty) {
      return null;
    }
    String? errorText = null;
    for (var transaction in gpuCluster.transactions!) {
      if (fromDate.isAfter(transaction.endDate) ||
          toDate.isBefore(transaction.startDate)) {
      } else {
        errorText = "Transaction date range overlaps with another transaction";
        return errorText;
      }
    }
    return errorText;
  }
}
