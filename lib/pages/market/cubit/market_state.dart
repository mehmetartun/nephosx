part of 'market_cubit.dart';

@immutable
sealed class MarketState {}

final class MarketInitial extends MarketState {}

final class MarketLoading extends MarketState {}

final class MarketLoaded extends MarketState {
  List<GpuCluster> gpuClusters;
  String? ownCompanyId;
  MarketLoaded({required this.gpuClusters, this.ownCompanyId});
}

final class MarketError extends MarketState {
  final String message;
  MarketError({required this.message});
}
