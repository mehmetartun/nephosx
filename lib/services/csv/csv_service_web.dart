import 'dart:convert';
import 'package:nephosx/model/gpu_cluster.dart';

import 'package:web/web.dart' as web;
import 'dart:js_interop';

import 'package:csv/csv.dart';

import '../../model/datacenter.dart';

class CsvService {
  /// Exports the given list of drinks to a CSV file and opens the share dialog.
  ///
  /// The CSV file will be named `drinks_export.csv` and stored in a temporary
  /// directory before being shared.
  Future<void> exportGpuClusters(List<GpuCluster> gpuClustersToExport) async {
    if (gpuClustersToExport.isEmpty) {
      // In a real app, you might want to return a status or show a notification.
      return;
    }

    // Define CSV headers.
    // The `imageBase64` is excluded as it's very large.
    final List<String> headers = [
      'id',
      'model_name',
      'quantity',
      'datacenter_id',
      'datacenter_name',
    ];

    // Map the drink list to a list of lists for CSV conversion.
    List<List<dynamic>> rows = [];
    rows.add(headers);
    for (var gpuCluster in gpuClustersToExport) {
      rows.add([
        gpuCluster.id,
        gpuCluster.device?.name,
        gpuCluster.quantity,
        gpuCluster.datacenterId,
        gpuCluster.datacenter?.name,
      ]);
    }

    // Convert the list of lists to a CSV string.
    final String csvData = const ListToCsvConverter().convert(rows);
    print(csvData);

    try {
      // Encode the CSV data to UTF-8
      final bytes = utf8.encode(csvData);
      // Create a blob from the bytes
      final blob = web.Blob(
        [bytes.toJS].toJS,
        web.BlobPropertyBag(type: 'text/csv'),
      );

      // Create a URL for the blob
      final url = web.URL.createObjectURL(blob);

      // try {
      //   // Try File System Access API (Save As)
      //   // Check if showSaveFilePicker exists on window
      //   if ((html.window as JSObject).has('showSaveFilePicker')) {
      //     final options = FileSystemSaveFilePickerOptions(
      //       suggestedName: 'gpu_clusters_export.csv',
      //       types: [
      //         FileSystemType(
      //           description: 'CSV File',
      //           accept:
      //               {
      //                     'text/csv': ['.csv'.toJS].toJS,
      //                   }.jsify()
      //                   as JSObject?,
      //         ),
      //       ].toJS,
      //     );

      //     final handle = await html.window.showSaveFilePicker(options).toDart;
      //     final writable = await handle.createWritable().toDart;
      //     await writable.write(blob as JSAny).toDart;
      //     await writable.close().toDart;

      //     html.URL.revokeObjectURL(url);
      //     return;
      //   }
      // } catch (e) {
      //   print('File System Access API failed or cancelled: $e');
      //   // Fallback to direct download
      // }

      // Create an anchor element and trigger a download
      final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
      anchor.href = url;
      anchor.download = 'gpu_clusters_export.csv';
      anchor.click();

      web.URL.revokeObjectURL(url);
    } catch (e) {
      print(e);
    }
  }

  Future<void> exportDatacenters(List<Datacenter> datacentersToExport) async {
    if (datacentersToExport.isEmpty) {
      // In a real app, you might want to return a status or show a notification.
      return;
    }

    // Define CSV headers.
    // The `imageBase64` is excluded as it's very large.
    final List<String> headers = ['id', 'name', 'tier', 'country', 'region'];

    // Map the drink list to a list of lists for CSV conversion.
    List<List<dynamic>> rows = [];
    rows.add(headers);
    for (var datacenter in datacentersToExport) {
      rows.add([
        datacenter.id,
        datacenter.name,
        datacenter.tier.rank,
        datacenter.address.country.description,
        datacenter.address.country.region.description,
      ]);
    }

    // Convert the list of lists to a CSV string.
    final String csvData = const ListToCsvConverter().convert(rows);
    print(csvData);

    try {
      // Encode the CSV data to UTF-8
      final bytes = utf8.encode(csvData);
      // Create a blob from the bytes
      final blob = web.Blob(
        [bytes.toJS].toJS,
        web.BlobPropertyBag(type: 'text/csv'),
      );

      // Create a URL for the blob
      final url = web.URL.createObjectURL(blob);

      // try {
      //   // Try File System Access API (Save As)
      //   // Check if showSaveFilePicker exists on window
      //   if ((html.window as JSObject).has('showSaveFilePicker')) {
      //     final options = FileSystemSaveFilePickerOptions(
      //       suggestedName: 'gpu_clusters_export.csv',
      //       types: [
      //         FileSystemType(
      //           description: 'CSV File',
      //           accept:
      //               {
      //                     'text/csv': ['.csv'.toJS].toJS,
      //                   }.jsify()
      //                   as JSObject?,
      //         ),
      //       ].toJS,
      //     );

      //     final handle = await html.window.showSaveFilePicker(options).toDart;
      //     final writable = await handle.createWritable().toDart;
      //     await writable.write(blob as JSAny).toDart;
      //     await writable.close().toDart;

      //     html.URL.revokeObjectURL(url);
      //     return;
      //   }
      // } catch (e) {
      //   print('File System Access API failed or cancelled: $e');
      //   // Fallback to direct download
      // }

      // Create an anchor element and trigger a download
      final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
      anchor.href = url;
      anchor.download = 'datacenters_export.csv';
      anchor.click();

      web.URL.revokeObjectURL(url);
    } catch (e) {
      print(e);
    }
  }
}
