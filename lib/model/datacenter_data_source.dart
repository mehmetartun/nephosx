import 'package:flutter/material.dart';

import 'datacenter.dart';

class DatacenterDataSource extends DataTableSource {
  // Generate some dummy dat

  final List<Datacenter> datacenters;
  // final User? user;
  final BuildContext context;

  final void Function(Datacenter datacenter) updateDatacenterRequest;
  // final double Function(GpuCluster, DateTime, DateTime) priceCalculator;
  // final String? Function(GpuCluster, DateTime, DateTime) validator;
  // final void Function(GpuTransaction) onAddTransaction;

  DatacenterDataSource({
    required this.datacenters,
    // this.user,
    required this.context,
    required this.updateDatacenterRequest,
    // required this.priceCalculator,
    // required this.validator,
    // required this.onAddTransaction,
  });

  List<DataColumn> getColumns({
    required void Function<T>(
      Comparable<T> Function(Datacenter d) getField,
      int columnIndex,
      bool ascending,
    )
    sortFunction,
  }) {
    return [
      // DataColumn(
      //   label: Text(
      //     'GPU\nType',
      //     style: Theme.of(context).textTheme.labelMedium,
      //   ),
      //   onSort: (columnIndex, ascending) {
      //     sortFunction<String>(
      //       (d) =>
      //           "${d.producer?.name ?? 'ERROR'}\n${d.device?.name ?? 'ERROR'}",
      //       columnIndex,
      //       ascending,
      //     );
      //   },
      // ),
      DataColumn(
        label: Text('Name', style: Theme.of(context).textTheme.labelMedium),
        onSort: (columnIndex, ascending) {
          sortFunction<String>((d) => d.name, columnIndex, ascending);
        },
      ),
      DataColumn(
        label: Text('Region', style: Theme.of(context).textTheme.labelMedium),
        onSort: (columnIndex, ascending) {
          sortFunction<String>(
            (d) => d.address.country.region.description,
            columnIndex,
            ascending,
          );
        },
      ),
      DataColumn(
        headingRowAlignment: MainAxisAlignment.start,
        label: Text(
          'Country',
          // textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        onSort: (columnIndex, ascending) {
          sortFunction<String>(
            (d) => d.address.country.description,
            columnIndex,
            ascending,
          );
        },
      ),
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        label: Text('Rel %', style: Theme.of(context).textTheme.labelMedium),
        onSort: (columnIndex, ascending) {
          sortFunction<num>((d) => d.tier.rank, columnIndex, ascending);
        },
      ),
      DataColumn(
        label: Text("Status"),
        headingRowAlignment: MainAxisAlignment.center,
      ),

      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        label: Text('Edit', style: Theme.of(context).textTheme.labelMedium),
        // onSort: (columnIndex, ascending) {
        //   sortFunction<DateTime>((d) => d.startDate, columnIndex, ascending);
        // },
      ),
      // DataColumn(
      //   label: Text('', style: Theme.of(context).textTheme.labelMedium),
      //   // onSort: (columnIndex, ascending) {
      //   //   sortFunction<DateTime>((d) => d.startDate, columnIndex, ascending);
      //   // },
      // ),
    ];
  }

  // Sorting Logic
  void sort<T>(Comparable<T> Function(Datacenter d) getField, bool ascending) {
    datacenters.sort((a, b) {
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
    if (index >= datacenters.length) return null;
    final datacenter = datacenters[index];

    return DataRow(
      cells: [
        // DataCell(
        //   Row(
        //     children: [
        //       gpuCluster.producer?.base64Image != null
        //           ? Padding(
        //               padding: const EdgeInsets.only(right: 3.0),
        //               child: Image.memory(
        //                 base64Decode(gpuCluster.producer!.base64Image!),
        //                 width: 16,
        //                 height: 16,
        //               ),
        //             )
        //           : Container(),
        //       Text(gpuCluster.device?.name ?? 'X'),
        //     ],
        //   ),
        // ),
        DataCell(Text(datacenter.name)),
        DataCell(Text(datacenter.address.country.region.description)),
        DataCell(
          Text(
            "${datacenter.address.country.flagUnicode} ${datacenter.address.country.description}",
          ),
        ),
        DataCell(
          Align(
            alignment: Alignment.center,
            child: Text(datacenter.tier.roman),
          ),
        ),

        DataCell(
          Align(
            alignment: Alignment.center,
            child: datacenter.iso27001
                ? Icon(Icons.check_circle, color: Colors.green)
                : Container(),
          ),
        ),

        DataCell(
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () => updateDatacenterRequest(datacenter),
              child: Text("Edit"),
            ),
          ),
        ),
        // DataCell(
        //   TextButton(
        //     onPressed: () async {
        //       await showDialog(
        //         context: context,
        //         builder: (context) {
        //           return MaxWidthBox(
        //             maxWidth: 800,
        //             child: Dialog(
        //               child: Stack(
        //                 children: [
        //                   Padding(
        //                     padding: const EdgeInsets.all(20.0),
        //                     child: GpuClusterInfo(gpuCluster: gpuCluster),
        //                   ),
        //                   Positioned(
        //                     top: 10,
        //                     right: 10,
        //                     child: IconButton(
        //                       icon: Icon(Icons.close),
        //                       onPressed: () {
        //                         Navigator.pop(context);
        //                       },
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           );
        //         },
        //       );
        //     },
        //     child: Text("View"),
        //   ),
        // ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => datacenters.length;

  @override
  int get selectedRowCount => 0;
}
