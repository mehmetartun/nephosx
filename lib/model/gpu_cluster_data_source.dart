import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nephosx/model/gpu_cluster.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../widgets/dialogs/add_transaction_dialog.dart';
import '../widgets/gpu_cluster_info.dart';
import 'enums.dart';
import 'gpu_transaction.dart';
import 'user.dart';

class GpuClusterDataSource extends DataTableSource {
  // Generate some dummy dat

  final List<GpuCluster> gpuClusters;
  final User? user;
  final BuildContext context;
  final double Function(GpuCluster, DateTime, DateTime) priceCalculator;
  final String? Function(GpuCluster, DateTime, DateTime) validator;
  final void Function(GpuTransaction) onAddTransaction;

  GpuClusterDataSource({
    required this.gpuClusters,
    this.user,
    required this.context,
    required this.priceCalculator,
    required this.validator,
    required this.onAddTransaction,
  });

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
        DataCell(
          Text(
            "${gpuCluster.producer?.name ?? 'ERROR'}\n${gpuCluster.device?.name ?? 'ERROR'}",
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
        DataCell(
          Text(
            gpuCluster.availabilityDate == null
                ? "ERROR"
                : DateFormat("dd MMM yy").format(gpuCluster.availabilityDate!),
          ),
        ),
        DataCell(
          gpuCluster.rentalPrices.length == 0
              ? Text('12 months / \$9.99/hr')
              : DropdownButton(
                  value: gpuCluster.rentalPrices.first,
                  items: gpuCluster.rentalPrices
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            "${e.numberOfMonths} mo @ ${NumberFormat.currency(locale: 'en_US', symbol: '\$').format(e.priceInUsdPerHour)}/hr",
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {},
                ),
        ),
        DataCell(
          gpuCluster.companyId == user?.companyId
              ? Text("Own GPU")
              : Row(
                  children: [
                    FilledButton(
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            if (user!.type == UserType.corporate ||
                                user!.type == UserType.corporateAdmin) {
                              return AddTransactionDialog(
                                gpuCluster: gpuCluster,
                                priceCalculator: priceCalculator,
                                validator: validator,
                                buyers: [user!.company!],
                                datacenter: gpuCluster.datacenter!,
                                onAddTransaction: onAddTransaction,
                              );
                            } else {
                              return AlertDialog(
                                title: Text("Not Authorized"),
                                content: Text(
                                  "You are currently not authorized to transact on this platform.",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("OK"),
                                  ),
                                ],
                              );
                            }
                          },
                        );
                      },
                      child: Text("Buy"),
                    ),
                    OutlinedButton(onPressed: () {}, child: Text("Bid")),
                  ],
                ),
        ),
        DataCell(
          TextButton(
            child: Text("More Info"),
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
                            child: GpuClusterInfo(gpuCluster: gpuCluster),
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
