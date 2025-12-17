import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nephosx/model/gpu_cluster.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../blocs/authentication/authentication_bloc.dart';
import '../widgets/views/gpu_cluster_info_view.dart';

class GpuClusterDataSource extends DataTableSource {
  // Generate some dummy dat

  final List<GpuCluster> gpuClusters;
  // final User? user;
  final BuildContext context;

  final void Function(GpuCluster gpuCluster) updateGpuClusterRequest;
  final void Function(GpuCluster gpuCluster) gpuClusterDetailRequest;
  final bool showSerialNumber;

  // final double Function(GpuCluster, DateTime, DateTime) priceCalculator;
  // final String? Function(GpuCluster, DateTime, DateTime) validator;
  // final void Function(GpuTransaction) onAddTransaction;

  GpuClusterDataSource({
    required this.gpuClusters,
    // this.user,
    required this.context,
    required this.updateGpuClusterRequest,
    required this.gpuClusterDetailRequest,
    this.showSerialNumber = true,
    // required this.priceCalculator,
    // required this.validator,
    // required this.onAddTransaction,
  });

  List<DataColumn> getColumns({
    required void Function<T>(
      Comparable<T> Function(GpuCluster d) getField,
      int columnIndex,
      bool ascending,
    )
    sortFunction,
  }) {
    return [
      if (showSerialNumber)
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
                "${d.producer?.name ?? 'ERROR'}\n${d.device?.name ?? 'ERROR'}",
            columnIndex,
            ascending,
          );
        },
      ),

      DataColumn(
        label: Text('GPU\n#', style: Theme.of(context).textTheme.labelMedium),
        onSort: (columnIndex, ascending) {
          sortFunction<num>((d) => d.quantity, columnIndex, ascending);
        },
      ),

      DataColumn(
        label: Text('Region', style: Theme.of(context).textTheme.labelMedium),
        onSort: (columnIndex, ascending) {
          sortFunction<String>(
            (d) => d.datacenter?.address.country.region.description ?? '',
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
          sortFunction<num>((d) => d.teraFlops ?? 0, columnIndex, ascending);
        },
      ),
      DataColumn(
        label: Text('RAM/GPU', style: Theme.of(context).textTheme.labelMedium),
        onSort: (columnIndex, ascending) {
          sortFunction<num>(
            (d) => d.perGpuVramInGb ?? 0,
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
      DataColumn(
        label: Text('Edit', style: Theme.of(context).textTheme.labelMedium),
        // onSort: (columnIndex, ascending) {
        //   sortFunction<DateTime>((d) => d.startDate, columnIndex, ascending);
        // },
      ),
      DataColumn(
        label: Text('', style: Theme.of(context).textTheme.labelMedium),
        // onSort: (columnIndex, ascending) {
        //   sortFunction<DateTime>((d) => d.startDate, columnIndex, ascending);
        // },
      ),
    ];
  }

  // Sorting Logic
  void sort<T>(Comparable<T> Function(GpuCluster d) getField, bool ascending) {
    gpuClusters.sort((a, b) {
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
    if (index >= gpuClusters.length) return null;
    final gpuCluster = gpuClusters[index];

    return DataRow(
      cells: [
        if (showSerialNumber)
          DataCell(
            InkWell(
              onTap: () {
                gpuClusterDetailRequest(gpuCluster);
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: Text(
                  gpuCluster.serialNumber ?? 'ABC123456XY',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
          ),
        DataCell(
          Row(
            children: [
              gpuCluster.producer?.base64Image != null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 3.0),
                      child: Image.memory(
                        base64Decode(gpuCluster.producer!.base64Image!),
                        width: 16,
                        height: 16,
                      ),
                    )
                  : Container(),
              Text(gpuCluster.device?.name ?? 'X'),
            ],
          ),
        ),
        DataCell(Text(gpuCluster.quantity.toString())),

        DataCell(
          Text(gpuCluster.datacenter?.address.country.region.description ?? ''),
        ),
        DataCell(Text(gpuCluster.datacenter?.address.country.iso2 ?? '')),
        DataCell(Text(gpuCluster.datacenter?.tier.roman ?? '')),

        DataCell(Text(gpuCluster.teraFlops?.toString() ?? "15200")),
        DataCell(Text("${gpuCluster.perGpuVramInGb?.toString() ?? "80"} GB")),
        DataCell(Text(DateFormat("dd MMM yy").format(gpuCluster.startDate))),
        DataCell(Text(DateFormat("dd MMM yy").format(gpuCluster.endDate))),
        DataCell(
          (BlocProvider.of<AuthenticationBloc>(
                    context,
                  ).user?.canUpdateGpuCluster ??
                  false)
              ? TextButton(
                  onPressed: !gpuCluster.canEdit
                      ? null
                      : () => updateGpuClusterRequest(gpuCluster),
                  child: Text(!gpuCluster.canEdit ? "Locked" : "Edit"),
                )
              : SizedBox.shrink(),
        ),
        DataCell(
          TextButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) {
                  return MaxWidthBox(
                    maxWidth: 800,
                    child: Dialog(
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: GpuClusterInfoView(gpuCluster: gpuCluster),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Text("View"),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => gpuClusters.length;

  @override
  int get selectedRowCount => 0;
}
