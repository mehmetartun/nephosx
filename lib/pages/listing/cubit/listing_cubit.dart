import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_functions/cloud_functions.dart';

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
  List<User> corporateUsers = [];
  final HttpsCallable _addListingFunction = FirebaseFunctions.instance
      .httpsCallable('listing-addListing');

  final User? user;
  final DatabaseRepository databaseRepository;

  void prepareData() {
    for (var gpuCluster in gpuClusters) {
      gpuCluster.addTransactions(transactions);
      gpuCluster.addListings(listings);
    }

    for (var listing in listings) {
      listing.addGpuCluster(gpuClusters);
      listing.addDatacenter(datacenters);
    }
  }

  void dataRefresh(
    List<GpuTransaction> transactions,
    List<GpuCluster> gpuClusters,
    List<Listing> listings,
    List<User> corporateUsers,
  ) {
    this.transactions = transactions;
    this.gpuClusters = gpuClusters;
    this.listings = listings;
    this.corporateUsers = corporateUsers;

    prepareData();
    if (state is ListingLoaded || state is ListingInitial) {
      emit(
        ListingLoaded(
          listings: listings,
          gpuClusters: gpuClusters,
          transactions: transactions,
        ),
      );
    }
  }

  void init() async {
    // listings = await databaseRepository.getListings(
    //   companyId: user?.companyId,
    //   status: ListingStatus.active,
    // );
    // print("Got Listings");
    // gpuClusters = await databaseRepository.getGpuClusters(
    //   companyId: user?.companyId,
    // );
    // print("Got GpuClusters");
    // datacenters = await databaseRepository.getDatacenters(
    //   companyId: user?.companyId,
    // );
    // print("Got Datacenters");
    // transactions = await databaseRepository.getGpuTransactions(
    //   companyId: user?.companyId,
    // );
    // print("Got Transactions");
    // for (var gpuCluster in gpuClusters) {
    //   gpuCluster.addTransactions(transactions);
    //   gpuCluster.addListings(listings);
    // }

    // for (var listing in listings) {
    //   listing.addGpuCluster(gpuClusters);
    //   listing.addDatacenter(datacenters);
    // }

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
      await _addListingFunction.call(listing.toJson());
    } on FirebaseFunctionsException catch (e) {
      emit(ListingError(error: e.toString()));
      return;
    } catch (e) {
      emit(ListingError(error: e.toString()));
      return;
    }
    // init();
  }
}
