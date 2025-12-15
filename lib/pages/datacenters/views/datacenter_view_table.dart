import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nephosx/pages/market/cubit/market_cubit.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../model/datacenter.dart';
import '../../../model/datacenter_data_source.dart';
import '../../../model/enums.dart';
import '../../../model/gpu_cluster.dart';
import '../../../model/gpu_cluster_data_source.dart';
import '../../../model/gpu_transaction.dart';
import '../../../model/user.dart';
import '../../../services/platform_settings/platform_settings_service.dart';
import '../../../widgets/dialogs/add_transaction_dialog.dart';
import '../../../widgets/filter_container.dart';
import '../../../widgets/filter_range_slider.dart';
import '../../../widgets/formfields/date_formfield.dart';
import '../../../widgets/gpu_cluster_info.dart';

class DatacentersViewTable extends StatefulWidget {
  const DatacentersViewTable({
    Key? key,
    required this.datacenters,
    required this.addDatacenterRequest,
    required this.updateDatacenterRequest,
  }) : super(key: key);
  final List<Datacenter> datacenters;
  final Function() addDatacenterRequest;
  final Function(Datacenter) updateDatacenterRequest;

  @override
  State<DatacentersViewTable> createState() => _DatacentersViewTableState();
}

class _DatacentersViewTableState extends State<DatacentersViewTable> {
  String? selectedDeviceId;
  int? clusterSize;
  Set<Country> countries = {};
  Set<AddressRegion> regions = {};
  Country? country;
  AddressRegion? region;
  DateTime? availabilityFrom;
  DateTime? availabilityTo;
  DatacenterTier? tier;
  late DatacenterDataSource datacenterDataSource;
  int? _sortColumnIndex;
  bool? _sortAscending;
  User? user;

  @override
  void initState() {
    super.initState();
    widget.datacenters.forEach((datacenter) {
      countries.add(datacenter.address.country);
      regions.add(datacenter.address.country.region);
    });
    datacenterDataSource = DatacenterDataSource(
      datacenters: widget.datacenters,
      context: context,
      updateDatacenterRequest: widget.updateDatacenterRequest,
    );
  }

  // void updateSource() {
  //   gpuClusterDataSource = GpuClusterDataSource(
  //     gpuClusters: widget.gpuClusters
  //         .where((element) {
  //           if (selectedDeviceId == null) return true;
  //           return element.deviceId == selectedDeviceId;
  //         })
  //         .where((element) {
  //           if (clusterSize == null) return true;
  //           return element.quantity == clusterSize;
  //         })
  //         .where((element) {
  //           if (country == null) return true;
  //           return element.datacenter?.address.country == country;
  //         })
  //         .where((element) {
  //           if (region == null) return true;
  //           return element.datacenter?.address.country.region == region;
  //         })
  //         .where((gpuCluster) {
  //           if (availabilityFrom == null) return true;
  //           return gpuCluster.startDate?.isAfter(availabilityFrom!) ?? true;
  //         })
  //         .where((gpuCluster) {
  //           if (availabilityTo == null) return true;
  //           return gpuCluster.startDate?.isBefore(availabilityTo!) ?? true;
  //         })
  //         .where((element) {
  //           if (tier == null) return true;
  //           return element.datacenter?.tier == tier;
  //         })
  //         .toList(),
  //     context: context,
  //     updateGpuClusterRequest: widget.updateGpuClusterRequest,
  //   );
  // }

  // void updateCountries() {
  //   if (region != null) {
  //     countries = widget.gpuClusters
  //         .where((e) => e.datacenter != null)
  //         .where(
  //           (gpuCluster) =>
  //               gpuCluster.datacenter!.address.country.region == region,
  //         )
  //         .map((gpuCluster) => gpuCluster.datacenter!.address.country)
  //         .toSet();
  //   } else {
  //     countries = widget.gpuClusters
  //         .where((e) => e.datacenter != null)
  //         .map((gpuCluster) => gpuCluster.datacenter!.address.country)
  //         .toSet();
  //   }
  // }

  void _sort<T>(
    Comparable<T> Function(Datacenter d) getField,
    int columnIndex,
    bool ascending,
  ) {
    setState(() {
      datacenterDataSource.sort<T>(getField, ascending);
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Container(
                        //   padding: const EdgeInsets.all(20.0),
                        //   decoration: BoxDecoration(
                        //     // color: Theme.of(context).colorScheme.surface,
                        //     borderRadius: BorderRadius.circular(0),
                        //     border: Border.all(
                        //       color: Theme.of(context).colorScheme.outline,
                        //     ),
                        //   ),
                        //   child: Column(
                        //     children: [
                        //       Row(
                        //         mainAxisAlignment:
                        //             MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           Row(
                        //             children: [
                        //               Icon(Icons.filter_alt_outlined),
                        //               SizedBox(width: 10),
                        //               Text("Filters"),
                        //             ],
                        //           ),
                        //           FilledButton.tonal(
                        //             onPressed: () {
                        //               setState(() {
                        //                 region = null;
                        //                 country = null;
                        //                 clusterSize = null;
                        //                 selectedDeviceId = null;
                        //                 availabilityFrom = null;
                        //                 availabilityTo = null;
                        //                 tier = null;
                        //                 updateSource();
                        //               });
                        //             },
                        //             child: Text("Clear"),
                        //           ),
                        //         ],
                        //       ),
                        //       SizedBox(height: 20),
                        //       SizedBox(
                        //         height: 90,
                        //         child: Row(
                        //           children: [
                        //             Flexible(
                        //               flex: 1,
                        //               fit: FlexFit.tight,
                        //               child: DropdownMenuFormField<String?>(
                        //                 // width: double.infinity,
                        //                 label: Text("GPU Model"),
                        //                 initialSelection: selectedDeviceId,
                        //                 onSelected: (value) {
                        //                   setState(() {
                        //                     selectedDeviceId = value;
                        //                     updateSource();
                        //                   });
                        //                 },
                        //                 dropdownMenuEntries: [
                        //                   DropdownMenuEntry(
                        //                     value: null,
                        //                     label: "All",
                        //                   ),
                        //                   ...PlatformSettingsService
                        //                       .instance
                        //                       .platformSettings
                        //                       .devices
                        //                       .map((device) {
                        //                         return DropdownMenuEntry(
                        //                           value: device.id,
                        //                           label: device.name,
                        //                         );
                        //                       })
                        //                       .toList(),
                        //                 ],
                        //               ),
                        //             ),
                        //             SizedBox(width: 20),
                        //             Flexible(
                        //               flex: 1,
                        //               fit: FlexFit.tight,
                        //               child: DropdownMenuFormField<int?>(
                        //                 // width: double.infinity,
                        //                 label: Text("Cluster Size"),
                        //                 initialSelection: clusterSize,
                        //                 onSelected: (value) {
                        //                   setState(() {
                        //                     clusterSize = value;
                        //                     updateSource();
                        //                   });
                        //                 },
                        //                 dropdownMenuEntries: [
                        //                   DropdownMenuEntry(
                        //                     value: null,
                        //                     label: "All",
                        //                   ),
                        //                   ...[1, 2, 4, 8, 16, 32, 64, 128].map((
                        //                     clustersize,
                        //                   ) {
                        //                     return DropdownMenuEntry(
                        //                       value: clustersize,
                        //                       label: clustersize.toString(),
                        //                     );
                        //                   }).toList(),
                        //                 ],
                        //               ),
                        //             ),
                        //             SizedBox(width: 20),
                        //             Flexible(
                        //               flex: 1,
                        //               fit: FlexFit.tight,
                        //               child:
                        //                   DropdownMenuFormField<AddressRegion?>(
                        //                     label: Text("Region"),
                        //                     // width: double.infinity,
                        //                     initialSelection: region,
                        //                     onSelected: (value) {
                        //                       setState(() {
                        //                         region = value;
                        //                         if (country?.region != region) {
                        //                           country = null;
                        //                         }
                        //                         updateCountries();
                        //                         updateSource();
                        //                       });
                        //                     },
                        //                     dropdownMenuEntries: [
                        //                       DropdownMenuEntry(
                        //                         value: null,
                        //                         label: "All",
                        //                       ),
                        //                       ...regions.map((region) {
                        //                         return DropdownMenuEntry(
                        //                           value: region,
                        //                           label: region.title,
                        //                         );
                        //                       }).toList(),
                        //                     ],
                        //                   ),
                        //             ),
                        //             SizedBox(width: 20),
                        //             Flexible(
                        //               flex: 1,
                        //               fit: FlexFit.tight,
                        //               child: DropdownMenuFormField<Country?>(
                        //                 label: Text("Country"),
                        //                 // width: double.infinity,
                        //                 menuStyle: MenuStyle(),
                        //                 initialSelection: country,
                        //                 onSelected: (value) {
                        //                   setState(() {
                        //                     country = value;
                        //                     updateSource();
                        //                   });
                        //                 },
                        //                 dropdownMenuEntries: [
                        //                   DropdownMenuEntry(
                        //                     value: null,
                        //                     label: "All",
                        //                   ),
                        //                   ...countries.map((country) {
                        //                     return DropdownMenuEntry(
                        //                       value: country,
                        //                       label: country.description,
                        //                     );
                        //                   }).toList(),
                        //                 ],
                        //               ),
                        //             ),
                        //             SizedBox(width: 20),
                        //             Flexible(
                        //               flex: 1,
                        //               fit: FlexFit.tight,
                        //               child:
                        //                   DropdownMenuFormField<
                        //                     DatacenterTier?
                        //                   >(
                        //                     label: Text("Tier"),

                        //                     // width: double.infinity,
                        //                     initialSelection: tier,
                        //                     onSelected: (value) {
                        //                       setState(() {
                        //                         tier = value;
                        //                         if (country?.region != region) {
                        //                           country = null;
                        //                         }
                        //                         updateCountries();
                        //                         updateSource();
                        //                       });
                        //                     },
                        //                     dropdownMenuEntries: [
                        //                       DropdownMenuEntry(
                        //                         value: null,
                        //                         label: "All",
                        //                       ),
                        //                       ...DatacenterTier.values.map((
                        //                         tier,
                        //                       ) {
                        //                         return DropdownMenuEntry(
                        //                           value: tier,
                        //                           label: tier.roman,
                        //                         );
                        //                       }).toList(),
                        //                     ],
                        //                   ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //       Row(
                        //         children: [
                        //           Flexible(
                        //             flex: 1,
                        //             fit: FlexFit.tight,
                        //             child: DateTimeFormField(
                        //               clearButton: true,
                        //               border: const OutlineInputBorder(),
                        //               // trailing: IconButton(
                        //               //   icon: Icon(Icons.close),
                        //               //   onPressed: () {
                        //               //     setState(() {
                        //               //       availabilityFrom = null;
                        //               //     });
                        //               //   },
                        //               // ),
                        //               onClear: () {
                        //                 setState(() {
                        //                   availabilityFrom = null;
                        //                   updateSource();
                        //                 });
                        //               },
                        //               labelText: "Availability from",
                        //               initialValue: availabilityFrom,
                        //               // lastDate: availabilityTo,
                        //               onChanged: (value) {
                        //                 setState(() {
                        //                   availabilityFrom = value;

                        //                   if (value != null &&
                        //                       (availabilityTo?.isBefore(
                        //                             value,
                        //                           ) ??
                        //                           false)) {
                        //                     availabilityTo = value;
                        //                   }
                        //                   updateSource();
                        //                 });
                        //               },
                        //             ),
                        //           ),
                        //           SizedBox(width: 20),
                        //           Flexible(
                        //             flex: 1,
                        //             fit: FlexFit.tight,
                        //             child: DateTimeFormField(
                        //               clearButton: true,
                        //               border: const OutlineInputBorder(),
                        //               labelText: "Availability to",
                        //               initialValue: availabilityTo,
                        //               onClear: () {
                        //                 setState(() {
                        //                   availabilityTo = null;
                        //                   updateSource();
                        //                 });
                        //               },
                        //               onChanged: (value) {
                        //                 setState(() {
                        //                   availabilityTo = value;
                        //                   if (value != null &&
                        //                       (availabilityFrom?.isAfter(
                        //                             value,
                        //                           ) ??
                        //                           false)) {
                        //                     availabilityFrom = value;
                        //                   }
                        //                   updateSource();
                        //                 });
                        //               },
                        //             ),
                        //           ),

                        //           SizedBox(width: 20),
                        //           Flexible(
                        //             flex: 1,
                        //             fit: FlexFit.tight,
                        //             child: Container(),
                        //           ),
                        //           SizedBox(width: 20),
                        //           Flexible(
                        //             flex: 1,
                        //             fit: FlexFit.tight,
                        //             child: Container(),
                        //           ),
                        //           SizedBox(width: 20),
                        //           Flexible(
                        //             flex: 1,
                        //             fit: FlexFit.tight,
                        //             child: Container(),
                        //           ),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              "Data Centers",
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            Spacer(),
                            OutlinedButton.icon(
                              label: Text("Add Data Center"),
                              icon: Icon(Icons.add),
                              onPressed: widget.addDatacenterRequest,
                            ),
                          ],
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
                              sortColumnIndex: _sortColumnIndex,
                              sortAscending: _sortAscending ?? true,
                              source: datacenterDataSource,
                              // source: GpuClusterDataSource(
                              //   gpuClusters: widget.gpuClusters,
                              //   user: user,
                              //   context: context,
                              //   priceCalculator: widget.priceCalculator,
                              //   validator: widget.validator,
                              //   onAddTransaction: widget.onAddTransaction,
                              // ),
                              horizontalMargin: 10,
                              columnSpacing: 10,
                              columns: datacenterDataSource.getColumns(
                                sortFunction:
                                    <T>(
                                      Comparable<T> Function(Datacenter d)
                                      getField,
                                      int columnIndex,
                                      bool ascending,
                                    ) {
                                      setState(() {
                                        datacenterDataSource.sort<T>(
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
