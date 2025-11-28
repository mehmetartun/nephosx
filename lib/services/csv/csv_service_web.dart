import 'dart:convert';
import 'package:share_plus/share_plus.dart';
import 'package:web/web.dart' as html;
import 'dart:js_interop';
import 'package:csv/csv.dart';

import '../../model/drink.dart';

class CsvService {
  /// Exports the given list of drinks to a CSV file and opens the share dialog.
  ///
  /// The CSV file will be named `drinks_export.csv` and stored in a temporary
  /// directory before being shared.
  Future<void> exportDrinks(List<Drink> drinksToExport) async {
    if (drinksToExport.isEmpty) {
      // In a real app, you might want to return a status or show a notification.
      return;
    }

    // Define CSV headers.
    // The `imageBase64` is excluded as it's very large.
    final List<String> headers = ['id', 'name', 'drinkType', 'imageBase64'];

    // Map the drink list to a list of lists for CSV conversion.
    List<List<dynamic>> rows = [];
    rows.add(headers);
    for (var drink in drinksToExport) {
      rows.add([
        drink.id,
        drink.name,
        drink.drinkType.name,
        drink.imageBase64, // Using the getter from the Drink model
      ]);
    }

    // Convert the list of lists to a CSV string.
    final String csvData = const ListToCsvConverter().convert(rows);

    try {
      // Encode the CSV data to UTF-8
      final bytes = utf8.encode(csvData);
      // Create a blob from the bytes
      final blob = html.Blob(
        [bytes.toJS, html.BlobPropertyBag(type: 'text/csv;charset=utf-8')].toJS,
      );
      // Create a URL for the blob
      final url = html.URL.createObjectURL(blob);
      // Create an anchor element and trigger a download
      await SharePlus.instance.share(
        ShareParams(
          uri: Uri.tryParse(url),
          text: 'Here is the exported drinks CSV file.',
        ),
      );
    } catch (e) {}
  }
}
