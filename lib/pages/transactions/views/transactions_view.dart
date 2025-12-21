import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nephosx/widgets/transaction_table.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../blocs/transactions/transactions_bloc.dart'
    hide TransactionsState;
import '../../../model/datacenter.dart';
import '../../../model/enums.dart';
import '../../../model/gpu_transaction.dart';
import '../../../model/transactions_data_source.dart';
import '../../../model/user.dart';
import '../../../services/platform_settings/platform_settings_service.dart';
import '../../../widgets/formfields/date_formfield.dart';
import '../cubit/transactions_cubit.dart';

enum TransactionType { all, buy, sell }

class TransactionsView extends StatefulWidget {
  const TransactionsView({
    super.key,
    required this.transactions,
    required this.onExport,
  });
  final List<GpuTransaction> transactions;
  final void Function(List<GpuTransaction>, {String prefix}) onExport;

  @override
  State<TransactionsView> createState() => _TransactionsViewState();
}

class _TransactionsViewState extends State<TransactionsView> {
  List<GpuTransaction> transactions = [];
  List<GpuTransaction> buys = [];
  List<GpuTransaction> sells = [];
  late TransactionsDataSource transactionsDataSource;

  TransactionType? selectedTransactions = null;

  late User? user;
  bool? _sortAscending;
  int? _sortColumnIndex;
  AddressRegion? region;
  Country? country;
  DatacenterTier? tier;
  int? clusterSize;
  String? selectedDeviceId;
  DateTime? availabilityFrom;
  DateTime? availabilityTo;
  Set<Country> countries = {};
  Set<AddressRegion> regions = {};
  StreamSubscription<TransactionsState>? dataSubscription;
  TextEditingController? searchController;

  @override
  void dispose() {
    searchController?.dispose();
    dataSubscription?.cancel();
    super.dispose();
  }

  void _sort<T>(
    Comparable<T> Function(GpuTransaction d) getField,
    int columnIndex,
    bool ascending,
  ) {
    setState(() {
      transactionsDataSource.sort<T>(getField, ascending);
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    user = BlocProvider.of<AuthenticationBloc>(context).user;
    // transactions = widget.transactions.toList();
    dataSubscription = BlocProvider.of<TransactionsCubit>(context).stream
        .listen((state) {
          if (state is TransactionsLoaded) {
            setState(() {
              transactions = state.transactions;
              buys = state.transactions.where((e) {
                return user!.companyId == e.buyerCompanyId;
              }).toList();
              sells = state.transactions.where((e) {
                return user!.companyId == e.sellerCompanyId;
              }).toList();
              transactionsDataSource = TransactionsDataSource(
                transactions: state.transactions,
                user: user!,
                context: context,
              );
            });
          }
        });

    buys = transactions.where((e) {
      return user!.companyId == e.buyerCompanyId;
    }).toList();
    sells = transactions.where((e) {
      return user!.companyId == e.sellerCompanyId;
    }).toList();

    transactionsDataSource = TransactionsDataSource(
      transactions: transactions,
      user: user!,
      context: context,
    );
  }

  void updateSource(txns) {
    transactionsDataSource = TransactionsDataSource(
      transactions: txns,
      user: user!,
      context: context,
    );
  }

  void updateCountries() {
    if (region != null) {
      countries = widget.transactions
          .where(
            (tx) => tx.gpuCluster?.datacenter?.address.country.region == region,
          )
          .map((tx) => tx.gpuCluster!.datacenter!.address.country)
          .toSet();
    } else {
      countries = widget.transactions
          .where((tx) => tx.gpuCluster?.datacenter != null)
          .map((tx) => tx.gpuCluster!.datacenter!.address.country)
          .toSet();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: MaxWidthBox(
          maxWidth: 1200,
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "Transactions List",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Spacer(),
                  DropdownMenuFormField<TransactionType>(
                    label: Text("Export"),
                    initialSelection: selectedTransactions,
                    enableSearch: false,
                    dropdownMenuEntries: [
                      DropdownMenuEntry(
                        value: TransactionType.all,
                        label: "All",
                      ),
                      DropdownMenuEntry(
                        value: TransactionType.buy,
                        label: "Buys",
                      ),
                      DropdownMenuEntry(
                        value: TransactionType.sell,
                        label: "Sells",
                      ),
                    ],
                    onSelected: (val) {
                      switch (val) {
                        case TransactionType.all:
                          widget.onExport(
                            transactions,
                            prefix: "All_Transactions",
                          );
                          return;
                        case TransactionType.buy:
                          widget.onExport(buys, prefix: "Buy_Transactions");
                          return;
                        case TransactionType.sell:
                          widget.onExport(sells, prefix: "Sell_Transactions");
                          return;
                        default:
                          return;
                      }
                    },
                  ),
                  // OutlinedButton(
                  //   onPressed: () => widget.onExport(transactions),
                  //   child: Text("Export"),
                  // ),
                ],
              ),
              SizedBox(height: 20),

              // SizedBox(
              //   width: double.infinity,
              //   child: TransactionTable(transactions: transactions),
              // ),
              // SizedBox(height: 20),
              // Text("Buying"),
              // SizedBox(
              //   width: double.infinity,
              //   child: TransactionTable(transactions: buys),
              // ),
              // SizedBox(height: 20),
              // Text("Selling"),
              // SizedBox(
              //   width: double.infinity,
              //   child: TransactionTable(transactions: sells),
              // ),
              SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  // color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(0),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.filter_alt_outlined),
                            SizedBox(width: 10),
                            Text("Filters"),
                          ],
                        ),
                        FilledButton.tonal(
                          onPressed: () {
                            setState(() {
                              region = null;
                              country = null;
                              clusterSize = null;
                              selectedDeviceId = null;
                              availabilityFrom = null;
                              availabilityTo = null;
                              tier = null;
                              searchController?.text = "";
                              updateSource(transactions);
                            });
                          },
                          child: Text("Clear"),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      runSpacing: 10,
                      spacing: 10,
                      direction: Axis.horizontal,
                      children: [
                        SizedBox(
                          width: 250,
                          child: DateTimeFormField(
                            clearButton: true,
                            border: const OutlineInputBorder(),
                            // trailing: IconButton(
                            //   icon: Icon(Icons.close),
                            //   onPressed: () {
                            //     setState(() {
                            //       availabilityFrom = null;
                            //     });
                            //   },
                            // ),
                            onClear: () {
                              setState(() {
                                availabilityFrom = null;
                                // updateSource();
                              });
                            },
                            labelText: "From",
                            initialValue: availabilityFrom,
                            // lastDate: availabilityTo,
                            onChanged: (value) {
                              setState(() {
                                availabilityFrom = value;

                                if (value != null &&
                                    (availabilityTo?.isBefore(value) ??
                                        false)) {
                                  availabilityTo = value;
                                }
                                // updateSource();
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 250,
                          child: DateTimeFormField(
                            clearButton: true,
                            border: const OutlineInputBorder(),
                            labelText: "To",
                            initialValue: availabilityTo,
                            onClear: () {
                              setState(() {
                                availabilityTo = null;
                                // updateSource();
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                availabilityTo = value;
                                if (value != null &&
                                    (availabilityFrom?.isAfter(value) ??
                                        false)) {
                                  availabilityFrom = value;
                                }
                                // updateSource();
                              });
                            },
                          ),
                        ),
                        DropdownMenuFormField<String?>(
                          // width: double.infinity,
                          label: Text("GPU Model"),
                          initialSelection: selectedDeviceId,
                          enableSearch: false,
                          onSelected: (value) {
                            setState(() {
                              selectedDeviceId = value;
                              // updateSource();
                            });
                          },
                          dropdownMenuEntries: [
                            DropdownMenuEntry(value: null, label: "All"),
                            ...PlatformSettingsService
                                .instance
                                .platformSettings
                                .devices
                                .map((device) {
                                  return DropdownMenuEntry(
                                    value: device.id,
                                    label: device.name,
                                  );
                                })
                                .toList(),
                          ],
                        ),
                        DropdownMenuFormField<int?>(
                          // enableFilter: true,
                          // width: double.infinity,
                          label: Text("Cluster Size"),
                          // filterCallback: (entries, filter) {
                          //   return entries.where((entry) {
                          //     return entry.label.toLowerCase().contains(
                          //       filter.toLowerCase(),
                          //     );
                          //   }).toList();
                          // },
                          initialSelection: clusterSize,
                          enableSearch: false,
                          onSelected: (value) {
                            setState(() {
                              clusterSize = value;
                              // updateSource();
                            });
                          },
                          dropdownMenuEntries: [
                            DropdownMenuEntry(value: null, label: "All"),
                            ...[1, 2, 4, 8, 16, 32, 64, 128].map((clustersize) {
                              return DropdownMenuEntry(
                                value: clustersize,
                                label: clustersize.toString(),
                              );
                            }).toList(),
                          ],
                        ),
                        DropdownMenuFormField<AddressRegion?>(
                          label: Text("Region"),
                          // width: double.infinity,
                          initialSelection: region,
                          onSelected: (value) {
                            setState(() {
                              region = value;
                              if (country?.region != region) {
                                country = null;
                              }
                              updateCountries();
                              // updateSource();
                            });
                          },
                          dropdownMenuEntries: [
                            DropdownMenuEntry(value: null, label: "All"),
                            ...regions.map((region) {
                              return DropdownMenuEntry(
                                value: region,
                                label: region.title,
                              );
                            }).toList(),
                          ],
                        ),
                        DropdownMenuFormField<DatacenterTier?>(
                          label: Text("Tier"),
                          enableSearch: false,
                          // width: double.infinity,
                          initialSelection: tier,
                          onSelected: (value) {
                            setState(() {
                              tier = value;
                              if (country?.region != region) {
                                country = null;
                              }
                              updateCountries();
                              // updateSource();
                            });
                          },
                          dropdownMenuEntries: [
                            DropdownMenuEntry(value: null, label: "All"),
                            ...DatacenterTier.values.map((tier) {
                              return DropdownMenuEntry(
                                value: tier,
                                label: tier.roman,
                              );
                            }).toList(),
                          ],
                        ),
                        DropdownMenuFormField<Country?>(
                          label: Text("Country"),
                          // width: double.infinity,
                          menuStyle: MenuStyle(),
                          initialSelection: country,
                          enableSearch: false,
                          onSelected: (value) {
                            setState(() {
                              country = value;
                              // updateSource();
                            });
                          },
                          dropdownMenuEntries: [
                            DropdownMenuEntry(value: null, label: "All"),
                            ...countries.map((country) {
                              return DropdownMenuEntry(
                                value: country,
                                label: country.description,
                              );
                            }).toList(),
                          ],
                        ),
                        TextFormField(
                          // initialValue: "",
                          controller: searchController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Search S/N",
                          ),
                          onChanged: (value) {
                            setState(() {
                              List<GpuTransaction> filtered = widget
                                  .transactions
                                  .where((tx) {
                                    return tx.gpuCluster?.serialNumber.contains(
                                          value,
                                        ) ??
                                        false;
                                  })
                                  .toList();
                              updateSource(filtered);
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
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
                    showEmptyRows: false,

                    columnSpacing: 10,
                    sortColumnIndex: _sortColumnIndex,
                    sortAscending: _sortAscending ?? true,
                    header: Text("All Transactions"),
                    columns: transactionsDataSource.getColumns(
                      sortFunction:
                          <T>(
                            Comparable<T> Function(GpuTransaction d) getField,
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
                    source: transactionsDataSource,
                  ),
                ),
              ),
            ],
          ),

          // ListView.builder(
          //   itemCount: transactions.length,
          //   itemBuilder: (context, index) {
          //     return Container(
          //       margin: const EdgeInsets.all(10),
          //       child: Wrap(
          //         runSpacing: 10,
          //         spacing: 10,
          //         direction: Axis.horizontal,
          //         children: [
          //           LabeledText(
          //             value: transactions[index].id,
          //             label: "ID",
          //             position: LabelPosition.left,
          //           ),
          //           LabeledText(
          //             value: transactions[index].createdAt,
          //             label: "Transaction Date",
          //             position: LabelPosition.left,
          //             format: "dd MMM yyyy",
          //           ),
          //           LabeledText(
          //             value: transactions[index].createdAt,
          //             label: "Transaction Time",
          //             position: LabelPosition.left,
          //             format: "HH:mm:ss",
          //           ),
          //           LabeledText(
          //             value: Company.getCompanyFromId(
          //               companies,
          //               transactions[index].buyerCompanyId,
          //             ).name,
          //             label: "Buyer",
          //             position: LabelPosition.left,
          //           ),
          //           LabeledText(
          //             value: Company.getCompanyFromId(
          //               companies,
          //               transactions[index].sellerCompanyId,
          //             ).name,
          //             label: "Seller",
          //             position: LabelPosition.left,
          //           ),
          //           LabeledText(
          //             value: transactions[index].gpuClusterId,
          //             label: "GPU Cluster",
          //           ),
          //           LabeledText(
          //             value: transactions[index].startDate,
          //             label: "Start Date",
          //             position: LabelPosition.left,
          //             format: "dd MMM yyyy",
          //           ),
          //           LabeledText(
          //             value: transactions[index].endDate,
          //             label: "End Date",
          //             position: LabelPosition.left,
          //             format: "dd MMM yyyy",
          //           ),
          //         ],
          //       ),
          //     );
          //   },
          // ),
        ),
      ),
    );
  }
}
