import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nephosx/pages/transactions/views/transaction_detail_view.dart';
import 'package:nephosx/widgets/occupation_view_paint.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../model/gpu_cluster.dart';
import '../../../model/gpu_transaction.dart';
import '../../../model/listing.dart';
import '../../../model/listing_by_gpu_cluster_data_source.dart';
import '../../../model/transactions_data_source.dart';
import '../../../model/user.dart';

class GpuClusterDetailView extends StatefulWidget {
  const GpuClusterDetailView({
    super.key,
    required this.gpuCluster,
    required this.onBack,
    required this.user,
  });
  final GpuCluster gpuCluster;
  final void Function() onBack;
  final User user;

  @override
  State<GpuClusterDetailView> createState() => _GpuClusterDetailViewState();
}

class _GpuClusterDetailViewState extends State<GpuClusterDetailView> {
  late ListingByGpuClusterDataSource listingDataSource;
  late TransactionsDataSource transactionsDataSource;
  int? _sortColumnIndex;
  bool? _sortAscending;
  @override
  void initState() {
    super.initState();
    listingDataSource = ListingByGpuClusterDataSource(
      listings: widget.gpuCluster.listings,
      user: widget.user,
      context: context,
      validator: (_, _, _) {},
      onAddTransaction: (x) {},
    );
    transactionsDataSource = TransactionsDataSource(
      transactions: widget.gpuCluster.transactions,
      user: widget.user,
      context: context,
      showSerialNumber: true,
      onTransactionDetail: (transaction) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return TransactionDetailView(
              transaction: transaction,
              onCancel: () {
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
    );
  }

  void _sort<T>(
    Comparable<T> Function(Listing d) getField,
    int columnIndex,
    bool ascending,
  ) {
    setState(() {
      listingDataSource.sort<T>(getField, ascending);
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: MaxWidthBox(
          alignment: Alignment.topCenter,
          maxWidth: 900,
          child: Form(
            child: Column(
              children: [
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "GPU Cluster Detail",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Spacer(),
                    OutlinedButton(
                      onPressed: widget.onBack,
                      child: Text("Close"),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      child: Text(
                        widget.gpuCluster.serialNumber,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Row(
                      children: [
                        widget.gpuCluster.producer?.base64Image != null
                            ? Padding(
                                padding: const EdgeInsets.only(right: 3.0),
                                child: Image.memory(
                                  base64Decode(
                                    widget.gpuCluster.producer!.base64Image!,
                                  ),
                                  width: 16,
                                  height: 16,
                                ),
                              )
                            : Container(),
                        Text(widget.gpuCluster.device?.name ?? 'X'),
                      ],
                    ),
                    SizedBox(width: 10),

                    Text('${widget.gpuCluster.quantity}x'),
                    SizedBox(width: 10),
                    Text(
                      widget.gpuCluster.datacenter == null
                          ? 'X'
                          : '${widget.gpuCluster.datacenter!.address.country.flagUnicode} ${widget.gpuCluster.datacenter!.address.country.iso2}',
                    ),
                  ],
                ),
                SizedBox(height: 20),

                OccupationView(
                  fromDate: widget.gpuCluster.startDate,
                  toDate: widget.gpuCluster.endDate,
                  occupiedSlots: widget.gpuCluster.occupiedSlots,
                  listedSlots: widget.gpuCluster.listedSlots,
                  unListedSlots: widget.gpuCluster.unListedSlots,
                ),
                SizedBox(height: 20),
                if (widget.gpuCluster.listings.isNotEmpty) ...[
                  SizedBox(
                    width: double.infinity,
                    child: CardTheme(
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
                        header: Text("Listings on this GPU Cluster"),
                        sortColumnIndex: _sortColumnIndex,
                        sortAscending: _sortAscending ?? true,
                        source: listingDataSource,
                        horizontalMargin: 10,
                        columnSpacing: 10,
                        showEmptyRows: false,
                        rowsPerPage: widget.gpuCluster.listings.length,
                        columns: [
                          DataColumn(
                            label: Text(
                              'Start Date',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            onSort: (columnIndex, ascending) {
                              _sort<DateTime>(
                                (d) => d.startDate,
                                columnIndex,
                                ascending,
                              );
                            },
                          ),
                          DataColumn(
                            label: Text(
                              'End Date',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            onSort: (columnIndex, ascending) {
                              _sort<DateTime>(
                                (d) => d.endDate,
                                columnIndex,
                                ascending,
                              );
                            },
                          ),
                          DataColumn(
                            label: Text(
                              'Length (days)',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            onSort: (columnIndex, ascending) {
                              _sort<num>(
                                (d) => d.numberOfDays,
                                columnIndex,
                                ascending,
                              );
                            },
                          ),
                          DataColumn(
                            label: Text(
                              'Tenor/Price',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                if (widget.gpuCluster.transactions.isNotEmpty) ...[
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: CardTheme(
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
                        header: Text("Transactions on this GPU Cluster"),
                        sortColumnIndex: _sortColumnIndex,
                        sortAscending: _sortAscending ?? true,
                        source: transactionsDataSource,
                        horizontalMargin: 10,
                        columnSpacing: 10,
                        showEmptyRows: false,
                        rowsPerPage: widget.gpuCluster.transactions.length,
                        columns: transactionsDataSource.getColumns(
                          sortFunction:
                              <T>(
                                Comparable<T> Function(GpuTransaction d)
                                getField,
                                int columnIndex,
                                bool ascending,
                              ) {
                                setState(() {
                                  transactionsDataSource.sort<T>(
                                    getField,
                                    ascending,
                                  );
                                  _sortColumnIndex = columnIndex;
                                  _sortAscending = ascending;
                                });
                              },
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
