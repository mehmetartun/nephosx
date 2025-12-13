import '../../model/datacenter.dart';
import '../../model/gpu_cluster.dart';

class CsvService {
  /// Exports the given list of drinks to a CSV file and opens the share dialog.
  ///
  /// The CSV file will be named `drinks_export.csv` and stored in a temporary
  /// directory before being shared.
  // Future<void> exportDrinks(List<Drink> drinksToExport) async {
  //   return;
  // }
  Future<void> exportGpuClusters(List<GpuCluster> gpuClustersToExport) async {
    throw (UnimplementedError());
  }

  Future<void> exportDatacenters(List<Datacenter> datacentersToExport) async {
    throw (UnimplementedError());
  }
}
