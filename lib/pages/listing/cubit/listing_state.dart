part of 'listing_cubit.dart';

@immutable
sealed class ListingState {}

final class ListingInitial extends ListingState {}

final class ListingLoaded extends ListingState {
  final List<Listing> listings;
  final List<GpuCluster> gpuClusters;
  final List<GpuTransaction> transactions;
  ListingLoaded({
    required this.listings,
    required this.gpuClusters,
    required this.transactions,
  });
}

final class ListingError extends ListingState {
  final String error;

  ListingError({required this.error});
}

final class ListingAddEdit extends ListingState {
  final Listing? listing;
  final GpuCluster gpuCluster;
  final Slot? slot;

  ListingAddEdit({this.listing, required this.gpuCluster, this.slot});
}
