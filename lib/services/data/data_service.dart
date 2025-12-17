import 'dart:async';

import '../../model/gpu_transaction.dart';
import '../../model/user.dart';

class DataService {
  static final DataService instance = DataService._internal();
  DataService._internal();

  StreamSubscription<List<GpuTransaction>>? transactionSubscription;

  Future<void> init(User user) async {
    if (user.companyId != null) {}
  }

  Future<void> close() async {
    await transactionSubscription?.cancel();
  }
}
