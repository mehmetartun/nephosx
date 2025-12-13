import 'dart:io';

import 'package:csv/csv.dart';
import 'package:nephosx/model/gpu_cluster.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../model/datacenter.dart';

class CsvService {
  /// Exports the given list of drinks to a CSV file and opens the share dialog.
  ///
  /// The CSV file will be named `drinks_export.csv` and stored in a temporary
  /// directory before being shared.
  ///
  ///
  Future<void> exportGpuClusters(List<GpuCluster> gpuClustersToExport) async {
    throw (UnimplementedError());
  }

  Future<void> exportDatacenters(List<Datacenter> datacentersToExport) async {
    throw (UnimplementedError());
  }
  // Future<void> exportDrinks(List<Drink> drinksToExport) async {
  //   if (drinksToExport.isEmpty) {
  //     // In a real app, you might want to return a status or show a notification.
  //     return;
  //   }

  //   // Define CSV headers.
  //   // The `imageBase64` is excluded as it's very large.
  //   final List<String> headers = ['id', 'name', 'drinkType', 'imageBase64'];

  //   // Map the drink list to a list of lists for CSV conversion.
  //   List<List<dynamic>> rows = [];
  //   rows.add(headers);
  //   for (var drink in drinksToExport) {
  //     rows.add([
  //       drink.id,
  //       drink.name,
  //       drink.drinkType.name,
  //       drink.imageBase64, // Using the getter from the Drink model
  //     ]);
  //   }

  //   // Convert the list of lists to a CSV string.
  //   final String csvData = const ListToCsvConverter().convert(rows);

  //   try {
  //     // Get a temporary directory to save the file.
  //     final Directory tempDir = await getTemporaryDirectory();
  //     final String filePath = '${tempDir.path}/drinks_export.csv';

  //     // Write the CSV data to a file.
  //     final File file = File(filePath);
  //     await file.writeAsString(csvData);

  //     // Use the share_plus package to share the file.
  //     await SharePlus.instance.share(
  //       ShareParams(
  //         files: [XFile(filePath)],
  //         text: 'Here is the exported drinks CSV file.',
  //       ),
  //     );
  //     file.deleteSync();
  //   } catch (e) {}
  // }
}
