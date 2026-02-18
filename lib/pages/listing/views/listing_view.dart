import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nephosx/widgets/occupation_view_paint.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../constants.dart';
import '../../../model/gpu_cluster.dart';
import '../../../model/gpu_transaction.dart';
import '../../../model/listing.dart';
import '../../../model/slot.dart';

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

  final void Function(Listing) onCancel;
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
          padding: kColumnPadding,
          child: MaxWidthBox(
            alignment: Alignment.topLeft,
            maxWidth: 1000,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Current Listings",
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
                      DataColumn(label: Text("Action")),
                    ],
                    rows: widget.listings
                        .map(
                          (listing) => DataRow(
                            cells: [
                              DataCell(Text(listing.gpuClusterId)),
                              DataCell(
                                Text(listing.gpuCluster?.device?.name ?? "N/A"),
                              ),
                              DataCell(Text(listing.datacenter?.name ?? "N/A")),

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
                                        listing
                                            .rentalPrices[0]
                                            .pricePerHourFormattedWithUnits,
                                      )
                                    : Text("N/A"),
                              ),

                              DataCell(
                                listing.rentalPrices.length > 1
                                    ? Text(
                                        listing
                                            .rentalPrices[1]
                                            .pricePerHourFormattedWithUnits,
                                      )
                                    : Text("N/A"),
                              ),
                              DataCell(
                                listing.rentalPrices.length > 2
                                    ? Text(
                                        listing
                                            .rentalPrices[2]
                                            .pricePerHourFormattedWithUnits,
                                      )
                                    : Text("N/A"),
                              ),
                              DataCell(
                                listing.rentalPrices.length > 3
                                    ? Text(
                                        listing
                                            .rentalPrices[3]
                                            .pricePerHourFormattedWithUnits,
                                      )
                                    : Text("N/A"),
                              ),
                              DataCell(
                                TextButton(
                                  onPressed: () async {
                                    bool? confirmed = await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Confirm"),
                                          content: Text(
                                            "Are you sure you want to cancel this listing?",
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context, false);
                                              },
                                              child: Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context, true);
                                              },
                                              child: Text("Confirm"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    if (confirmed == true) {
                                      widget.onCancel(listing);
                                    }
                                  },
                                  child: Text("Cancel"),
                                ),
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

                                        return Stack(
                                          children: [
                                            SimpleDialog(
                                              title: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text("Available Slots"),
                                                      IconButton(
                                                        icon: Icon(Icons.close),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    "For ${gpuCluster.producer?.name ?? 'ERROR'} ${gpuCluster.device?.name ?? 'ERROR'} ${gpuCluster.quantity}x",
                                                    style: Theme.of(
                                                      context,
                                                    ).textTheme.bodySmall,
                                                  ),
                                                ],
                                              ),
                                              children: [
                                                for (var s
                                                    in gpuCluster.unListedSlots
                                                        .where((s) {
                                                          return s.duration() >
                                                              Duration(
                                                                hours: 24,
                                                              );
                                                        })
                                                        .toList())
                                                  SimpleDialogOption(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "${DateFormat("yyyy-MM-dd").format(s.from)} to ${DateFormat("yyyy-MM-dd").format(s.to)} (${s.duration().inDays} days)",
                                                        ),
                                                        SizedBox(width: 10),
                                                        OutlinedButton(
                                                          child: Text("Select"),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                              context,
                                                              s,
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    onPressed: () {
                                                      // Navigator.pop(context, s);
                                                    },
                                                  ),
                                              ],
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
