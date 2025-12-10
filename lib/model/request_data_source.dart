import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nephosx/model/gpu_cluster.dart';
import 'package:nephosx/model/request.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../widgets/dialogs/add_transaction_dialog.dart';
import '../widgets/gpu_cluster_info.dart';
import 'enums.dart';
import 'gpu_transaction.dart';
import 'user.dart';

class RequestDataSource extends DataTableSource {
  // Generate some dummy dat

  final List<Request> requests;

  final BuildContext context;

  final void Function(Request) onSelectRequest;

  RequestDataSource({
    required this.requests,
    required this.context,
    required this.onSelectRequest,
  });

  // Sorting Logic
  void sort<T>(Comparable<T> Function(Request d) getField, bool ascending) {
    requests.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });

    // Important: Notify the widget that data has changed
    notifyListeners();
  }

  @override
  DataRow? getRow(int index) {
    if (index >= requests.length) return null;
    final request = requests[index];

    return DataRow(
      cells: [
        DataCell(Text(request.type.description)),
        DataCell(Text(DateFormat("dd MMM yy").format(request.requestDate))),
        DataCell(Text(request.status.description)),
        DataCell(
          TextButton(
            onPressed: () => onSelectRequest(request),
            child: Text("More Info"),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => requests.length;

  @override
  int get selectedRowCount => 0;
}
