import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../model/gpu_cluster.dart';
import '../../../model/gpu_transaction.dart';
import '../../../model/rental_price.dart';
import '../../../model/user.dart';
import '../../../repositories/database/database.dart';

part 'market_state.dart';

class MarketCubit extends Cubit<MarketState> {
  MarketCubit(this.databaseRepository, this.user) : super(MarketInitial());
  final DatabaseRepository databaseRepository;
  final User? user;
  List<GpuCluster> gpuClusters = [];

  void init() async {
    emit(MarketLoading());
    try {
      gpuClusters = await databaseRepository.getGpuClusters();
      emit(
        MarketLoaded(gpuClusters: gpuClusters, ownCompanyId: user?.companyId),
      );
    } catch (e) {
      emit(MarketError(message: e.toString()));
    }
  }

  void addTransaction(GpuTransaction data) async {
    if (user == null) {
      return;
    }
    await databaseRepository.addDocument(
      collectionPath: 'transactions',
      data: data.toJson(),
    );
    init();
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
    if (gpuCluster.transactions == null) {
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
