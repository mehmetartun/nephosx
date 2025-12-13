import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nephosx/model/gpu_cluster.dart';
import 'package:nephosx/model/listing.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../widgets/dialogs/add_transaction_dialog.dart';
import '../widgets/gpu_cluster_info.dart';
import 'enums.dart';
import 'gpu_transaction.dart';
import 'user.dart';

class ListingDataSource extends DataTableSource {
  // Generate some dummy dat

  final List<Listing> listings;
  final User? user;
  final BuildContext context;
  final double Function(GpuCluster, DateTime, DateTime) priceCalculator;
  final String? Function(GpuCluster, DateTime, DateTime) validator;
  final void Function(GpuTransaction) onAddTransaction;

  ListingDataSource({
    required this.listings,
    this.user,
    required this.context,
    required this.priceCalculator,
    required this.validator,
    required this.onAddTransaction,
  });

  // Sorting Logic
  void sort<T>(Comparable<T> Function(Listing d) getField, bool ascending) {
    listings.sort((a, b) {
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
    if (index >= listings.length) return null;
    final listing = listings[index];

    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              listing.gpuCluster?.producer?.base64Image != null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 3.0),
                      child: Image.memory(
                        base64Decode(
                          listing.gpuCluster!.producer!.base64Image!,
                        ),
                        width: 16,
                        height: 16,
                      ),
                    )
                  : Container(),
              Text(
                // "${listing.gpuCluster?.producer?.name ?? 'X'}\n${listing.gpuCluster?.device?.name ?? 'X'}",
                "${listing.gpuCluster?.device?.name ?? 'X'}",
              ),
            ],
          ),
        ),
        DataCell(Text(listing.gpuCluster?.quantity.toString() ?? "X")),
        DataCell(
          Text(
            listing
                    .gpuCluster
                    ?.datacenter
                    ?.address
                    .country
                    .region
                    .description ??
                'X',
          ),
        ),
        DataCell(
          Text(
            listing.gpuCluster?.datacenter == null
                ? 'X'
                : '${listing.gpuCluster!.datacenter!.address.country.flagUnicode} ${listing.gpuCluster!.datacenter!.address.country.iso2}',
          ),
        ),
        DataCell(Text(listing.gpuCluster?.datacenter?.tier.roman ?? 'X')),

        DataCell(Text(listing.gpuCluster?.teraFlops?.toString() ?? "ERROR")),
        DataCell(
          Text("${listing.gpuCluster?.perGpuVramInGb?.toString() ?? "X"} GB"),
        ),
        DataCell(Text(DateFormat("dd MMM yy").format(listing.startDate))),
        DataCell(
          user!.canSeePrices
              ? listing.rentalPrices.isEmpty
                    ? Text('No Price')
                    : DropdownButton(
                        value: listing.rentalPrices.first,
                        items: listing.rentalPrices
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
                      )
              : Text("Locked"),
        ),
        DataCell(
          listing.companyId == user?.companyId
              ? Text("Own GPU")
              : Row(
                  children: [
                    FilledButton(
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            if (user!.type == UserType.corporateTrader ||
                                user!.type == UserType.corporateAdmin) {
                              if (listing.gpuCluster != null &&
                                  listing.datacenter != null) {
                                return AddTransactionDialog(
                                  gpuCluster: listing.gpuCluster!,
                                  priceCalculator: priceCalculator,
                                  validator: validator,
                                  buyers: [user!.company!],
                                  datacenter: listing.datacenter!,
                                  onAddTransaction: onAddTransaction,
                                );
                              } else {
                                return Container();
                              }
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
                            child: listing.gpuCluster == null
                                ? Container()
                                : GpuClusterInfo(
                                    gpuCluster: listing.gpuCluster!,
                                  ),
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
  int get rowCount => listings.length;

  @override
  int get selectedRowCount => 0;
}
