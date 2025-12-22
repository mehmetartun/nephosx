import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../model/datacenter.dart';
import '../../../model/enums.dart';
import '../../../model/gpu_cluster.dart';
import '../../../model/gpu_cluster_data_source.dart';
import '../../../model/user.dart';
import '../../../services/platform_settings/platform_settings_service.dart';
import '../../../widgets/formfields/date_formfield.dart';

class GpuClustersViewTable extends StatefulWidget {
  const GpuClustersViewTable({
    Key? key,
    required this.gpuClusters,
    required this.addGpuClusterRequest,
    required this.updateGpuClusterRequest,
    required this.gpuClusterDetailRequest,
  }) : super(key: key);
  final List<GpuCluster> gpuClusters;
  final void Function() addGpuClusterRequest;
  final void Function(GpuCluster) updateGpuClusterRequest;
  final void Function(GpuCluster) gpuClusterDetailRequest;

  @override
  State<GpuClustersViewTable> createState() => _GpuClustersViewTableState();
}

class _GpuClustersViewTableState extends State<GpuClustersViewTable> {
  String? selectedDeviceId;
  int? clusterSize;
  Set<Country> countries = {};
  Set<AddressRegion> regions = {};
  Country? country;
  AddressRegion? region;
  DateTime? availabilityFrom;
  DateTime? availabilityTo;
  DatacenterTier? tier;
  late GpuClusterDataSource gpuClusterDataSource;
  int? _sortColumnIndex;
  bool? _sortAscending;
  User? user;

  @override
  void initState() {
    super.initState();
    widget.gpuClusters.where((e) => e.datacenter != null).forEach((gpuCluster) {
      countries.add(gpuCluster.datacenter!.address.country);
      regions.add(gpuCluster.datacenter!.address.country.region);
    });
    gpuClusterDataSource = GpuClusterDataSource(
      gpuClusters: widget.gpuClusters,
      context: context,
      updateGpuClusterRequest: widget.updateGpuClusterRequest,
      gpuClusterDetailRequest: widget.gpuClusterDetailRequest,
    );
  }

  void updateSource() {
    gpuClusterDataSource = GpuClusterDataSource(
      gpuClusters: widget.gpuClusters
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
            return element.datacenter?.address.country == country;
          })
          .where((element) {
            if (region == null) return true;
            return element.datacenter?.address.country.region == region;
          })
          .where((gpuCluster) {
            if (availabilityFrom == null) return true;
            return gpuCluster.startDate.isAfter(availabilityFrom!);
          })
          .where((gpuCluster) {
            if (availabilityTo == null) return true;
            return gpuCluster.startDate.isBefore(availabilityTo!);
          })
          .where((element) {
            if (tier == null) return true;
            return element.datacenter?.tier == tier;
          })
          .toList(),
      context: context,
      updateGpuClusterRequest: widget.updateGpuClusterRequest,
      gpuClusterDetailRequest: widget.gpuClusterDetailRequest,
    );
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

  void _sort<T>(
    Comparable<T> Function(GpuCluster d) getField,
    int columnIndex,
    bool ascending,
  ) {
    setState(() {
      gpuClusterDataSource.sort<T>(getField, ascending);
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
              maxWidth: 1100,
              child: FittedBox(
                child: SizedBox(
                  width: 1100,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              "GPU Clusters",
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            Spacer(),
                            OutlinedButton.icon(
                              onPressed: widget.addGpuClusterRequest,
                              icon: Icon(Icons.add),
                              label: Text("Add GPU Cluster"),
                            ),
                          ],
                        ),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                        tier = null;
                                        updateSource();
                                      });
                                    },
                                    child: Text("Clear"),
                                  ),
                                ],
                              ),

                              SizedBox(height: 20),
                              Wrap(
                                runSpacing: 10,
                                spacing: 10,
                                direction: Axis.horizontal,
                                children: [
                                  DropdownMenuFormField<String?>(
                                    // width: double.infinity,
                                    label: Text("GPU Model"),
                                    initialSelection: selectedDeviceId,
                                    onSelected: (value) {
                                      setState(() {
                                        selectedDeviceId = value;
                                        updateSource();
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
                                  DropdownMenuFormField<int?>(
                                    // width: double.infinity,
                                    label: Text("Cluster Size"),
                                    initialSelection: clusterSize,
                                    onSelected: (value) {
                                      setState(() {
                                        clusterSize = value;
                                        updateSource();
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
                                        updateSource();
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
                                  DropdownMenuFormField<Country?>(
                                    label: Text("Country"),
                                    // width: double.infinity,
                                    menuStyle: MenuStyle(),
                                    initialSelection: country,
                                    onSelected: (value) {
                                      setState(() {
                                        country = value;
                                        updateSource();
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
                                  DropdownMenuFormField<DatacenterTier?>(
                                    label: Text("Tier"),

                                    // width: double.infinity,
                                    initialSelection: tier,
                                    onSelected: (value) {
                                      setState(() {
                                        tier = value;
                                        if (country?.region != region) {
                                          country = null;
                                        }
                                        updateCountries();
                                        updateSource();
                                      });
                                    },
                                    dropdownMenuEntries: [
                                      DropdownMenuEntry(
                                        value: null,
                                        label: "All",
                                      ),
                                      ...DatacenterTier.values.map((tier) {
                                        return DropdownMenuEntry(
                                          value: tier,
                                          label: tier.roman,
                                        );
                                      }).toList(),
                                    ],
                                  ),
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
                                          updateSource();
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
                                          updateSource();
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 250,
                                    child: DateTimeFormField(
                                      clearButton: true,
                                      border: const OutlineInputBorder(),
                                      labelText: "Availability to",
                                      initialValue: availabilityTo,
                                      onClear: () {
                                        setState(() {
                                          availabilityTo = null;
                                          updateSource();
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
                                          updateSource();
                                        });
                                      },
                                    ),
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
                              sortColumnIndex: _sortColumnIndex,
                              sortAscending: _sortAscending ?? true,
                              source: gpuClusterDataSource,
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
                              columns: gpuClusterDataSource.getColumns(
                                sortFunction:
                                    <T>(
                                      Comparable<T> Function(GpuCluster d)
                                      getField,
                                      int columnIndex,
                                      bool ascending,
                                    ) {
                                      setState(() {
                                        gpuClusterDataSource.sort<T>(
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
