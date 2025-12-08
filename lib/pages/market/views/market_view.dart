import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nephosx/pages/market/cubit/market_cubit.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../model/enums.dart';
import '../../../model/gpu_cluster.dart';
import '../../../model/gpu_transaction.dart';
import '../../../model/user.dart';
import '../../../services/platform_settings/platform_settings_service.dart';
import '../../../widgets/dialogs/add_transaction_dialog.dart';
import '../../../widgets/filter_container.dart';
import '../../../widgets/filter_range_slider.dart';
import '../../../widgets/formfields/date_formfield.dart';
import '../../../widgets/gpu_cluster_info.dart';

class MarketView extends StatefulWidget {
  const MarketView({
    required this.onAddTransaction,
    Key? key,
    required this.gpuClusters,
    this.ownCompanyId,
    required this.priceCalculator,
    required this.validator,
  }) : super(key: key);
  final List<GpuCluster> gpuClusters;
  final String? ownCompanyId;
  final double Function(GpuCluster, DateTime, DateTime) priceCalculator;
  final String? Function(GpuCluster, DateTime, DateTime) validator;
  final void Function(GpuTransaction) onAddTransaction;

  @override
  State<MarketView> createState() => _MarketViewState();
}

class _MarketViewState extends State<MarketView> {
  String? selectedDeviceId;
  int? clusterSize;
  Set<Country> countries = {};
  Set<AddressRegion> regions = {};
  Country? country;
  AddressRegion? region;
  DateTime? availabilityFrom;
  DateTime? availabilityTo;

  @override
  void initState() {
    super.initState();
    widget.gpuClusters.where((e) => e.datacenter != null).forEach((gpuCluster) {
      countries.add(gpuCluster.datacenter!.address.country);
      regions.add(gpuCluster.datacenter!.address.country.region);
    });
  }

  void updateCountries() {
    if (region != null) {
      countries = widget.gpuClusters
          .where((e) => e.datacenter != null)
          .where(
            (gpuCluster) =>
                gpuCluster.datacenter!.address.country.region == region,
          )
          .map((gpuCluster) => gpuCluster.datacenter!.address.country)
          .toSet();
    } else {
      countries = widget.gpuClusters
          .where((e) => e.datacenter != null)
          .map((gpuCluster) => gpuCluster.datacenter!.address.country)
          .toSet();
    }
  }

  // void updateRegions() {
  //   if (country != null) {
  //     regions = widget.gpuClusters
  //         .where(
  //           (gpuCluster) =>
  //               gpuCluster.datacenter?.address.country == country,
  //         )
  //         .map(
  //           (gpuCluster) =>
  //               (gpuCluster.datacenter?.address.country.region ??
  //                   AddressRegion.gb),
  //         )
  //         .toSet();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    print(availabilityFrom);
    print(availabilityTo);
    User? user = context.read<AuthenticationBloc>().user;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: MaxWidthBox(
              maxWidth: 1200,
              child: FittedBox(
                child: SizedBox(
                  width: 1200,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    // child: ListView.builder(
                    //   shrinkWrap: true,
                    //   physics: const NeverScrollableScrollPhysics(),
                    //   itemBuilder: (context, index) {
                    //     return GpuClusterRowView(
                    //       gpuCluster: gpuClusters[index],
                    //       ownCompanyId: ownCompanyId,
                    //     );
                    //   },
                    //   itemCount: gpuClusters.length,
                    // ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      });
                                    },
                                    child: Text("Clear"),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              SizedBox(
                                height: 90,
                                child: Row(
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      fit: FlexFit.tight,
                                      child: DropdownMenuFormField<String?>(
                                        // width: double.infinity,
                                        label: Text("GPU Model"),
                                        initialSelection: selectedDeviceId,
                                        onSelected: (value) {
                                          setState(() {
                                            selectedDeviceId = value;
                                          });
                                        },
                                        dropdownMenuEntries: [
                                          DropdownMenuEntry(
                                            value: null,
                                            label: "All",
                                          ),
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
                                    ),
                                    SizedBox(width: 20),
                                    Flexible(
                                      flex: 1,
                                      fit: FlexFit.tight,
                                      child: DropdownMenuFormField<int?>(
                                        // width: double.infinity,
                                        label: Text("Cluster Size"),
                                        initialSelection: clusterSize,
                                        onSelected: (value) {
                                          setState(() {
                                            clusterSize = value;
                                          });
                                        },
                                        dropdownMenuEntries: [
                                          DropdownMenuEntry(
                                            value: null,
                                            label: "All",
                                          ),
                                          ...[1, 2, 4, 8, 16, 32, 64, 128].map((
                                            clustersize,
                                          ) {
                                            return DropdownMenuEntry(
                                              value: clustersize,
                                              label: clustersize.toString(),
                                            );
                                          }).toList(),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Flexible(
                                      flex: 1,
                                      fit: FlexFit.tight,
                                      child:
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
                                              });
                                            },
                                            dropdownMenuEntries: [
                                              DropdownMenuEntry(
                                                value: null,
                                                label: "All",
                                              ),
                                              ...regions.map((region) {
                                                return DropdownMenuEntry(
                                                  value: region,
                                                  label: region.title,
                                                );
                                              }).toList(),
                                            ],
                                          ),
                                    ),
                                    SizedBox(width: 20),
                                    Flexible(
                                      flex: 1,
                                      fit: FlexFit.tight,
                                      child: DropdownMenuFormField<Country?>(
                                        label: Text("Country"),
                                        // width: double.infinity,
                                        menuStyle: MenuStyle(),
                                        initialSelection: country,
                                        onSelected: (value) {
                                          setState(() {
                                            country = value;
                                          });
                                        },
                                        dropdownMenuEntries: [
                                          DropdownMenuEntry(
                                            value: null,
                                            label: "All",
                                          ),
                                          ...countries.map((country) {
                                            return DropdownMenuEntry(
                                              value: country,
                                              label: country.description,
                                            );
                                          }).toList(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 20),
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
                                          });
                                        },
                                        labelText: "Availability from",
                                        initialValue: availabilityFrom,
                                        // lastDate: availabilityTo,
                                        onChanged: (value) {
                                          setState(() {
                                            availabilityFrom = value;

                                            if (value != null &&
                                                (availabilityTo?.isBefore(
                                                      value,
                                                    ) ??
                                                    false)) {
                                              availabilityTo = value;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: DateTimeFormField(
                                        clearButton: true,
                                        border: const OutlineInputBorder(),
                                        // trailing: IconButton(
                                        //   icon: Icon(Icons.close),
                                        //   onPressed: () {
                                        //     setState(() {
                                        //       availabilityTo = null;
                                        //     });
                                        //   },
                                        // ),
                                        labelText: "Availability to",
                                        initialValue: availabilityTo,

                                        // firstDate: availabilityFrom?.subtract(
                                        //   Duration(days: 1),
                                        // ),
                                        onClear: () {
                                          setState(() {
                                            availabilityTo = null;
                                          });
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            availabilityTo = value;
                                            if (value != null &&
                                                (availabilityFrom?.isAfter(
                                                      value,
                                                    ) ??
                                                    false)) {
                                              availabilityFrom = value;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: Container(),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: Container(),
                                  ),
                                  // Flexible(
                                  //   flex: 1,
                                  //   fit: FlexFit.tight,
                                  //   child: FilterRangeSlider(
                                  //     title: "Selected Range: ",
                                  //     initialRangeValues: RangeValues(23, 45),
                                  //   ),
                                  // ),
                                  // SizedBox(width: 20),
                                  // Flexible(
                                  //   flex: 1,
                                  //   fit: FlexFit.tight,
                                  //   child: FilterRangeSlider(
                                  //     title: "Selected Range: ",
                                  //     initialRangeValues: RangeValues(78, 90),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20),
                        SizedBox(
                          height: 70,
                          child: Row(
                            children: [
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: FilterContainer(
                                  title: "Matching Clusters",
                                  subtitle: "6",
                                ),
                              ),
                              SizedBox(width: 20),
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: FilterContainer(
                                  title: "Total GPUs",
                                  subtitle: "40",
                                ),
                              ),
                              SizedBox(width: 20),
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: FilterContainer(
                                  title: "Regions",
                                  subtitle: "3",
                                ),
                              ),
                              SizedBox(width: 20),
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: FilterContainer(
                                  title: "Avg. Reliability",
                                  subtitle: "99.99%",
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          // padding: const EdgeInsets.all(20),
                          // color: Colors.red,
                          child: DataTable(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(0),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                            horizontalMargin: 10,
                            columnSpacing: 10,
                            columns: [
                              DataColumn(
                                label: Text(
                                  'GPU\nType',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelMedium,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'GPU\n#',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelMedium,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Region',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelMedium,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Location',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelMedium,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Rel %',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelMedium,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'TFlops',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelMedium,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'RAM/GPU',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelMedium,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Start\nDate',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelMedium,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Tenor\n/Price',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelMedium,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Actions',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelMedium,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'More',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelMedium,
                                ),
                              ),
                            ],
                            rows: widget.gpuClusters
                                .where((element) {
                                  if (selectedDeviceId == null) return true;
                                  return element.deviceId == selectedDeviceId;
                                })
                                .where((element) {
                                  if (clusterSize == null) return true;
                                  return element.quantity == clusterSize;
                                })
                                .where((element) {
                                  if (country == null) return true;
                                  return element.datacenter?.address.country ==
                                      country;
                                })
                                .where((element) {
                                  if (region == null) return true;
                                  return element
                                          .datacenter
                                          ?.address
                                          .country
                                          .region ==
                                      region;
                                })
                                .where((gpuCluster) {
                                  if (availabilityFrom == null) return true;
                                  return gpuCluster.availabilityDate?.isAfter(
                                        availabilityFrom!,
                                      ) ??
                                      true;
                                })
                                .where((gpuCluster) {
                                  if (availabilityTo == null) return true;
                                  return gpuCluster.availabilityDate?.isBefore(
                                        availabilityTo!,
                                      ) ??
                                      true;
                                })
                                .map((gpuCluster) {
                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        Text(
                                          "${gpuCluster.producer?.name ?? 'ERROR'}\n${gpuCluster.device?.name ?? 'ERROR'}",
                                        ),
                                      ),
                                      DataCell(
                                        Text(gpuCluster.quantity.toString()),
                                      ),
                                      DataCell(
                                        Text(
                                          gpuCluster
                                                  .datacenter
                                                  ?.address
                                                  .country
                                                  .region
                                                  .description ??
                                              '',
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          gpuCluster
                                                  .datacenter
                                                  ?.address
                                                  .country
                                                  .iso2 ??
                                              '',
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          gpuCluster.datacenter?.tier.roman ??
                                              '',
                                        ),
                                      ),

                                      DataCell(
                                        Text(
                                          gpuCluster.teraFlops?.toString() ??
                                              "15200",
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          "${gpuCluster.perGpuVramInGb?.toString() ?? "80"} GB",
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          gpuCluster.availabilityDate == null
                                              ? "ERROR"
                                              : DateFormat("dd MMM yy").format(
                                                  gpuCluster.availabilityDate!,
                                                ),
                                        ),
                                      ),
                                      DataCell(
                                        gpuCluster.rentalPrices.length == 0
                                            ? Text('12 months / \$9.99/hr')
                                            : DropdownButton(
                                                value: gpuCluster
                                                    .rentalPrices
                                                    .first,
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
                                                          return AddTransactionDialog(
                                                            gpuCluster:
                                                                gpuCluster,
                                                            priceCalculator: widget
                                                                .priceCalculator,
                                                            validator: widget
                                                                .validator,
                                                            buyers: [
                                                              user!.company!,
                                                            ],
                                                            datacenter:
                                                                gpuCluster
                                                                    .datacenter!,
                                                            onAddTransaction: widget
                                                                .onAddTransaction,
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Text("Buy"),
                                                  ),
                                                  OutlinedButton(
                                                    onPressed: () {},
                                                    child: Text("Bid"),
                                                  ),
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
                                                return SingleChildScrollView(
                                                  child: MaxWidthBox(
                                                    maxWidth: 600,
                                                    child: Dialog(
                                                      child: Stack(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets.all(
                                                                  20.0,
                                                                ),
                                                            child:
                                                                GpuClusterInfo(
                                                                  gpuCluster:
                                                                      gpuCluster,
                                                                ),
                                                          ),
                                                          Positioned(
                                                            top: 10,
                                                            right: 10,
                                                            child: IconButton(
                                                              icon: Icon(
                                                                Icons.close,
                                                              ),
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                  context,
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
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
                                })
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
