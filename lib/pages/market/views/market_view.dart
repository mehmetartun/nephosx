import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../model/gpu_cluster.dart';
import '../../../model/user.dart';
import '../../../widgets/filter_container.dart';
import '../../../widgets/filter_range_slider.dart';
import '../../../widgets/gpu_cluster_list_tile_view.dart';
import '../../../widgets/gpu_cluster_row_view.dart';

class MarketView extends StatelessWidget {
  const MarketView({Key? key, required this.gpuClusters, this.ownCompanyId})
    : super(key: key);
  final List<GpuCluster> gpuClusters;
  final String? ownCompanyId;

  @override
  Widget build(BuildContext context) {
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
                                children: [
                                  Icon(Icons.filter_alt_outlined),
                                  SizedBox(width: 10),
                                  Text("Filters"),
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
                                      child: FilterRangeSlider(
                                        title: "Selected Range: ",
                                        initialRangeValues: RangeValues(20, 80),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Flexible(
                                      flex: 1,
                                      fit: FlexFit.tight,
                                      child: FilterRangeSlider(
                                        title: "Selected Range: ",
                                        initialRangeValues: RangeValues(23, 45),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Flexible(
                                      flex: 1,
                                      fit: FlexFit.tight,
                                      child: FilterRangeSlider(
                                        title: "Selected Range: ",
                                        initialRangeValues: RangeValues(78, 90),
                                      ),
                                    ),
                                  ],
                                ),
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
                          color: Colors.red,
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
                                  'Ram/GPU',
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
                            rows: gpuClusters.map((gpuCluster) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Text("NVIDIA\n${gpuCluster.type.name}"),
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
                                      gpuCluster.datacenter?.tier.roman ?? '',
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
                                  DataCell(Text('2025-12-01')),
                                  DataCell(
                                    gpuCluster.rentalPrices.length == 0
                                        ? Text('12 months / \$9.99/hr')
                                        : DropdownButton(
                                            value:
                                                gpuCluster.rentalPrices.first,
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
                                                onPressed: () {},
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
                                      onPressed: () {},
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
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
