import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../model/gpu_cluster.dart';
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
}
