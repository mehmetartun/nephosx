import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../model/request.dart';
import '../../../model/request_data_source.dart';

class AdminOnboardingRequestsView extends StatefulWidget {
  const AdminOnboardingRequestsView({
    super.key,
    required this.requests,
    required this.onSelectRequest,
  });
  final List<Request> requests;
  final void Function(Request) onSelectRequest;

  @override
  State<AdminOnboardingRequestsView> createState() =>
      _AdminOnboardingRequestsViewState();
}

class _AdminOnboardingRequestsViewState
    extends State<AdminOnboardingRequestsView> {
  late RequestDataSource requestDataSource;
  int? _sortColumnIndex;
  bool? _sortAscending;

  @override
  void initState() {
    super.initState();
    requestDataSource = RequestDataSource(
      requests: widget.requests,
      context: context,
      onSelectRequest: widget.onSelectRequest,
    );
  }

  void _sort<T>(
    Comparable<T> Function(Request d) getField,
    int columnIndex,
    bool ascending,
  ) {
    setState(() {
      requestDataSource.sort<T>(getField, ascending);
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: MaxWidthBox(
          alignment: Alignment.topLeft,
          maxWidth: 600,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Requests", style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 20),
                CardTheme(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  color: Theme.of(context).colorScheme.surface,
                  margin: EdgeInsets.zero,
                  elevation: 0,
                  child: PaginatedDataTable(
                    columns: [
                      DataColumn(
                        label: Text(
                          'Type',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        onSort: (columnIndex, ascending) {
                          _sort<String>(
                            (d) => d.type.description,
                            columnIndex,
                            ascending,
                          );
                        },
                      ),
                      DataColumn(
                        label: Text(
                          'Request Date',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        onSort: (columnIndex, ascending) {
                          _sort<DateTime>(
                            (d) => d.requestDate,
                            columnIndex,
                            ascending,
                          );
                        },
                      ),
                      DataColumn(
                        label: Text(
                          'Status',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        onSort: (columnIndex, ascending) {
                          _sort<String>(
                            (d) => d.status.description,
                            columnIndex,
                            ascending,
                          );
                        },
                      ),
                      DataColumn(
                        label: Text(
                          'More Info',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                    ],
                    source: RequestDataSource(
                      requests: widget.requests,
                      context: context,
                      onSelectRequest: widget.onSelectRequest,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
