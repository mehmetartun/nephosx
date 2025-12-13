import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nephosx/widgets/dialogs/add_invitation_dialog.dart';
import 'package:nephosx/widgets/occupation_view_paint.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../model/gpu_cluster.dart';
import '../../../model/gpu_transaction.dart';
import '../../../model/invitaton.dart';
import '../../../model/listing.dart';
import '../../../model/slot.dart';
import '../../../model/user.dart';
import '../../../widgets/user_avatar.dart';

class ListingView extends StatefulWidget {
  const ListingView({
    Key? key,
    required this.listings,

    required this.onCancel,
    required this.gpuClusters,
    required this.transactions,

    required this.requestAddListing,
  }) : super(key: key);
  final List<Listing> listings;
  final List<GpuTransaction> transactions;

  final void Function() onCancel;
  final List<GpuCluster> gpuClusters;

  final void Function({required GpuCluster gpuCluster, required Slot slot})
  requestAddListing;

  @override
  State<ListingView> createState() => _ListingViewState();
}

class _ListingViewState extends State<ListingView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: MaxWidthBox(
            alignment: Alignment.topLeft,
            maxWidth: 1000,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Listings",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),

                Theme(
                  data: Theme.of(context).copyWith(
                    dataTableTheme: DataTableThemeData(
                      columnSpacing: 8,
                      horizontalMargin: 8,
                      dataTextStyle: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text("GPU Cluster Id")),
                      DataColumn(label: Text("Device")),
                      DataColumn(label: Text("Datacenter")),
                      DataColumn(label: Text("From")),
                      DataColumn(label: Text("To")),
                      DataColumn(label: Text("Px1")),
                      DataColumn(label: Text("Px2")),
                      DataColumn(label: Text("Px3")),
                      DataColumn(label: Text("Px4")),
                    ],
                    rows: widget.listings
                        .map(
                          (listing) => DataRow(
                            cells: [
                              DataCell(Text(listing.gpuClusterId)),
                              DataCell(Text(listing.datacenter?.name ?? "N/A")),
                              DataCell(
                                Text(listing.gpuCluster?.device?.name ?? "N/A"),
                              ),

                              DataCell(
                                Text(
                                  DateFormat(
                                    "yyyy-MM-dd",
                                  ).format(listing.startDate),
                                ),
                              ),
                              DataCell(
                                Text(
                                  DateFormat(
                                    "yyyy-MM-dd",
                                  ).format(listing.endDate),
                                ),
                              ),
                              DataCell(
                                listing.rentalPrices.length > 0
                                    ? Text(
                                        "${listing.rentalPrices[0].numberOfMonths}m @ \$${NumberFormat("0.000").format(listing.rentalPrices[0].priceInUsdPerHour)}",
                                      )
                                    : Text("N/A"),
                              ),

                              DataCell(
                                listing.rentalPrices.length > 1
                                    ? Text(
                                        "${listing.rentalPrices[1].numberOfMonths}m @ \$${NumberFormat("0.000").format(listing.rentalPrices[1].priceInUsdPerHour)}",
                                      )
                                    : Text("N/A"),
                              ),
                              DataCell(
                                listing.rentalPrices.length > 2
                                    ? Text(
                                        "${listing.rentalPrices[2].numberOfMonths}m @ \$${NumberFormat("0.000").format(listing.rentalPrices[2].priceInUsdPerHour)}",
                                      )
                                    : Text("N/A"),
                              ),
                              DataCell(
                                listing.rentalPrices.length > 3
                                    ? Text(
                                        "${listing.rentalPrices[3].numberOfMonths}m @ \$${NumberFormat("0.000").format(listing.rentalPrices[3].priceInUsdPerHour)}",
                                      )
                                    : Text("N/A"),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
                Divider(),
                Text(
                  "GPU Clusters",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),

                Theme(
                  data: Theme.of(context).copyWith(
                    dataTableTheme: DataTableThemeData(
                      columnSpacing: 8,
                      horizontalMargin: 8,
                      dataTextStyle: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text("GPU Cluster Id")),
                      DataColumn(label: Text("GPU Model")),
                      DataColumn(label: Text("Number of Txs")),
                      DataColumn(label: Text("Availability")),
                    ],
                    rows: widget.gpuClusters
                        .map(
                          (gpuCluster) => DataRow(
                            cells: [
                              DataCell(
                                TextButton(
                                  child: Text(gpuCluster.id),
                                  onPressed: () async {
                                    Slot? slot = await showDialog<Slot>(
                                      context: context,
                                      builder: (context) {
                                        var slots = gpuCluster.unListedSlots
                                            .where((s) {
                                              return s.duration() >
                                                  Duration(hours: 24);
                                            })
                                            .toList();

                                        if (slots.isEmpty) {
                                          return AlertDialog(
                                            title: Text("No availability"),
                                            content: Text(
                                              "No availability for this GPU cluster",
                                            ),
                                            actions: [
                                              TextButton(
                                                child: Text("OK"),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          );
                                        }

                                        return SimpleDialog(
                                          title: Text("Select Slot"),
                                          children: [
                                            for (var s
                                                in gpuCluster.unListedSlots
                                                    .where((s) {
                                                      return s.duration() >
                                                          Duration(hours: 24);
                                                    })
                                                    .toList())
                                              SimpleDialogOption(
                                                child: Text(
                                                  "${DateFormat("yyyy-MM-dd HH:mm:ss").format(s.from)} - ${DateFormat("yyyy-MM-dd HH:mm:ss").format(s.to)}",
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context, s);
                                                },
                                              ),
                                          ],
                                        );
                                      },
                                    );

                                    if (slot != null) {
                                      widget.requestAddListing(
                                        gpuCluster: gpuCluster,
                                        slot: slot,
                                      );
                                    }
                                  },
                                ),
                              ),
                              DataCell(Text(gpuCluster.device?.name ?? "")),
                              DataCell(
                                Text(gpuCluster.transactions.length.toString()),
                              ),
                              DataCell(
                                SizedBox(
                                  width: 300,
                                  child: OccupationView(
                                    occupiedSlots: gpuCluster.occupiedSlots,
                                    listedSlots: gpuCluster.listedSlots,
                                    unListedSlots: gpuCluster.unListedSlots,
                                    fromDate: gpuCluster.startDate,
                                    toDate: gpuCluster.endDate,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
                Text(
                  "Transactions",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),

                Theme(
                  data: Theme.of(context).copyWith(
                    dataTableTheme: DataTableThemeData(
                      columnSpacing: 8,
                      horizontalMargin: 8,
                      dataTextStyle: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text("GPU Cluster Id")),
                      DataColumn(label: Text("Number of Txs")),
                    ],
                    rows: widget.transactions
                        .map(
                          (transaction) => DataRow(
                            cells: [
                              DataCell(Text(transaction.id)),
                              DataCell(Text(transaction.gpuClusterId)),
                            ],
                          ),
                        )
                        .toList(),
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
