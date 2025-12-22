import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'gpu_transaction.dart';
import 'user.dart';

class TransactionsDataSource extends DataTableSource {
  // Generate some dummy dat

  final List<GpuTransaction> transactions;
  final User user;
  final BuildContext context;
  final bool showSerialNumber;

  // final String? Function(GpuCluster, DateTime, DateTime) validator;
  // final void Function(GpuTransaction) onAddTransaction;

  TransactionsDataSource({
    required this.transactions,
    required this.user,
    required this.context,
    this.showSerialNumber = true,
    // required this.validator,
    // required this.onAddTransaction,
  });

  // Sorting Logic
  void sort<T>(
    Comparable<T> Function(GpuTransaction d) getField,
    bool ascending,
  ) {
    transactions.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });

    // Important: Notify the widget that data has changed
    notifyListeners();
  }

  List<DataColumn> getColumns({
    required void Function<T>(
      Comparable<T> Function(GpuTransaction d) getField,
      int columnIndex,
      bool ascending,
    )
    sortFunction,
  }) {
    return [
      DataColumn(
        label: Text(
          "Direction",
          style: Theme.of(context).textTheme.labelMedium,
        ),
        onSort: (columnIndex, ascending) {
          sortFunction<String>(
            (d) {
              if (d.buyerCompanyId == user.companyId) {
                return "BUY";
              } else {
                return "SELL";
              }
            },
            columnIndex,
            ascending,
          );
        },
      ),
      DataColumn(
        label: Text(
          'Serial\nNumber',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        // onSort: (columnIndex, ascending) {
        //   sortFunction<String>((d) => d.serialNumber, columnIndex, ascending);
        // },
      ),
      DataColumn(
        label: Text(
          'GPU\nType',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        onSort: (columnIndex, ascending) {
          sortFunction<String>(
            (d) =>
                "${d.gpuCluster?.producer?.name ?? 'ERROR'}\n${d.gpuCluster?.device?.name ?? 'ERROR'}",
            columnIndex,
            ascending,
          );
        },
      ),

      DataColumn(
        label: Text('GPU\n#', style: Theme.of(context).textTheme.labelMedium),
        onSort: (columnIndex, ascending) {
          sortFunction<num>(
            (d) => d.gpuCluster?.quantity ?? 0,
            columnIndex,
            ascending,
          );
        },
      ),
      // if (showSerialNumber)
      // DataColumn(
      //   label: Text(
      //     'Serial\nNumber',
      //     style: Theme.of(context).textTheme.labelMedium,
      //   ),
      //   // onSort: (columnIndex, ascending) {
      //   //   sortFunction<String>((d) => d.serialNumber, columnIndex, ascending);
      //   // },
      // ),
      DataColumn(
        label: Text('Region', style: Theme.of(context).textTheme.labelMedium),
        onSort: (columnIndex, ascending) {
          sortFunction<String>(
            (d) => d.datacenter?.address.country.region.description ?? 'X',
            columnIndex,
            ascending,
          );
        },
      ),
      DataColumn(
        label: Text('Location', style: Theme.of(context).textTheme.labelMedium),
        onSort: (columnIndex, ascending) {
          sortFunction<String>(
            (d) => d.datacenter?.address.country.description ?? '',
            columnIndex,
            ascending,
          );
        },
      ),
      DataColumn(
        label: Text('Rel %', style: Theme.of(context).textTheme.labelMedium),
        onSort: (columnIndex, ascending) {
          sortFunction<num>(
            (d) => d.datacenter?.tier.rank ?? 0,
            columnIndex,
            ascending,
          );
        },
      ),
      DataColumn(
        label: Text('TFlops', style: Theme.of(context).textTheme.labelMedium),
        onSort: (columnIndex, ascending) {
          sortFunction<num>(
            (d) => d.gpuCluster?.teraFlops ?? 0,
            columnIndex,
            ascending,
          );
        },
      ),
      DataColumn(
        label: Text('RAM/GPU', style: Theme.of(context).textTheme.labelMedium),
        onSort: (columnIndex, ascending) {
          sortFunction<num>(
            (d) => d.gpuCluster?.perGpuVramInGb ?? 0,
            columnIndex,
            ascending,
          );
        },
      ),
      DataColumn(
        label: Text(
          'Start\nDate',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        onSort: (columnIndex, ascending) {
          sortFunction<DateTime>((d) => d.startDate, columnIndex, ascending);
        },
      ),
      DataColumn(
        label: Text(
          'End\nDate',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        onSort: (columnIndex, ascending) {
          sortFunction<DateTime>((d) => d.endDate, columnIndex, ascending);
        },
      ),
    ];
  }

  @override
  DataRow? getRow(int index) {
    if (index >= transactions.length) return null;
    final transaction = transactions[index];

    return DataRow(
      cells: [
        DataCell(
          Text(transaction.buyerCompanyId == user.companyId ? "BUY" : "SELL"),
        ),
        DataCell(Text(transaction.gpuCluster?.serialNumber ?? 'XXX')),
        DataCell(
          Row(
            children: [
              transaction.gpuCluster?.producer?.base64Image != null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 3.0),
                      child: Image.memory(
                        base64Decode(
                          transaction.gpuCluster!.producer!.base64Image!,
                        ),
                        width: 16,
                        height: 16,
                      ),
                    )
                  : Container(),
              Text(transaction.gpuCluster?.device?.name ?? 'X'),
            ],
          ),
        ),
        DataCell(Text(transaction.gpuCluster?.quantity.toString() ?? "X")),

        // DataCell(Text(transaction.gpuCluster?.serialNumber ?? 'XXX')),
        DataCell(
          Text(
            transaction.datacenter?.address.country.region.description ?? 'X',
          ),
        ),
        DataCell(
          Text(
            transaction.datacenter == null
                ? 'X'
                : '${transaction.datacenter!.address.country.flagUnicode} ${transaction.datacenter!.address.country.iso2}',
          ),
        ),
        DataCell(Text(transaction.datacenter?.tier.roman ?? 'X')),

        DataCell(
          Text(transaction.gpuCluster?.teraFlops?.toString() ?? "ERROR"),
        ),
        DataCell(
          Text(
            "${transaction.gpuCluster?.perGpuVramInGb?.toString() ?? "X"} GB",
          ),
        ),
        DataCell(Text(DateFormat("dd MMM yy").format(transaction.startDate))),
        DataCell(Text(DateFormat("dd MMM yy").format(transaction.endDate))),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => transactions.length;

  @override
  int get selectedRowCount => 0;
}
