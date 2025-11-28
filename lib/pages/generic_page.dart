import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/database/database.dart';

class GenericPage extends StatefulWidget {
  const GenericPage({super.key});

  @override
  State<GenericPage> createState() => _GenericPageState();
}

class _GenericPageState extends State<GenericPage> {
  bool _isLoading = false;
  String _statusMessage = '';

  Future<void> _uploadCsvToFirestore() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Reading CSV...';
    });

    try {
      // Load the CSV file from assets
      final String csvString = await rootBundle.loadString(
        'assets/images3/image_data.csv',
      );

      // Parse the CSV string
      final List<List<dynamic>> csvList = const CsvToListConverter().convert(
        csvString,
      );

      if (csvList.isEmpty) {
        setState(() {
          _statusMessage = 'CSV file is empty.';
          _isLoading = false;
        });
        return;
      }

      // Get the database repository
      final databaseRepository = RepositoryProvider.of<DatabaseRepository>(
        context,
      );

      // Skip the header row (first row)
      for (int i = 1; i < csvList.length; i++) {
        final row = csvList[i];
        if (row.length >= 2) {
          final String fileName = row[0].toString();
          final String base64String = row[1].toString();

          await databaseRepository.saveImageData(
            fileName: fileName,
            base64String: base64String,
          );
          setState(() {
            _statusMessage = 'Uploading: $fileName';
          });
        }
      }

      setState(() {
        _statusMessage = 'CSV data uploaded successfully!';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error uploading CSV: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Generic Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : _uploadCsvToFirestore,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Upload Image Data CSV to Firestore'),
            ),
            const SizedBox(height: 20),
            Text(_statusMessage),
          ],
        ),
      ),
    );
  }
}
