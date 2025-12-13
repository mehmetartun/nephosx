import 'package:bloc/bloc.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:meta/meta.dart';

import '../../../model/datacenter.dart';
import '../../../model/gpu_cluster.dart';
import '../../../model/gpu_transaction.dart';
import '../../../model/listing.dart';
import '../../../model/slot.dart';
import '../../../model/user.dart';
import '../../../repositories/database/database.dart';

part 'listing_state.dart';

class ListingCubit extends Cubit<ListingState> {
  ListingCubit(this.user, this.databaseRepository) : super(ListingInitial());
  List<Listing> listings = [];
  List<GpuCluster> gpuClusters = [];
  List<GpuTransaction> transactions = [];
  List<Datacenter> datacenters = [];
  final HttpsCallable addListingFunction = FirebaseFunctions.instance
      .httpsCallable('addListing');

  final HttpsCallable testFunc = FirebaseFunctions.instance.httpsCallable(
    'testFunc',
  );

  final HttpsCallable addTransaction = FirebaseFunctions.instance.httpsCallable(
    'addTransaction',
  );

  final User? user;
  final DatabaseRepository databaseRepository;
  void init() async {
    listings = await databaseRepository.getListings(companyId: user?.companyId);
    gpuClusters = await databaseRepository.getGpuClusters(
      companyId: user?.companyId,
    );
    datacenters = await databaseRepository.getDatacenters(
      companyId: user?.companyId,
    );
    transactions = await databaseRepository.getGpuTransactions(
      companyId: user?.companyId,
    );
    for (var gpuCluster in gpuClusters) {
      gpuCluster.addTransactions(transactions);
      gpuCluster.addListings(listings);
    }

    for (var listing in listings) {
      listing.addGpuCluster(gpuClusters);
      listing.addDatacenter(datacenters);
    }

    emit(
      ListingLoaded(
        listings: listings,
        gpuClusters: gpuClusters,
        transactions: transactions,
      ),
    );
  }

  void onCancel() {
    emit(ListingInitial());
    init();
  }

  void requestAddListing({required GpuCluster gpuCluster, required Slot slot}) {
    emit(ListingAddEdit(gpuCluster: gpuCluster, slot: slot));
  }

  // void requestEditListing({required Listing listing}) {
  //   emit(ListingAddEdit(listing: listing));
  // }

  void updateListing({required Listing listing}) {
    emit(
      ListingLoaded(
        listings: listings,
        gpuClusters: gpuClusters,
        transactions: transactions,
      ),
    );
  }

  void addListing({required Listing listing}) async {
    emit(ListingInitial());
    try {
      await addListingFunction.call(listing.toJson());
    } on FirebaseFunctionsException catch (e) {
      emit(ListingError(error: e.toString()));
      return;
    } catch (e) {
      emit(ListingError(error: e.toString()));
      return;
    }
    init();
  }
}
