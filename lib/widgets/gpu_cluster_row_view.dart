import 'package:flutter/material.dart';
import 'package:nephosx/model/gpu_cluster.dart';
import 'package:nephosx/widgets/gpu_cluster_list_tile_view.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'occupation_view_paint.dart';
import 'property_badge.dart';

// enum GpuClusterListTileViewType { listTile, compact }

class GpuClusterRowView extends StatelessWidget {
  const GpuClusterRowView({
    super.key,
    required this.gpuCluster,
    required this.ownCompanyId,
    this.viewType = GpuClusterListTileViewType.compact,
  });
  final GpuCluster gpuCluster;
  final String? ownCompanyId;
  final GpuClusterListTileViewType viewType;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        // color: gpuCluster.companyId == ownCompanyId
        //     ? Theme.of(context).colorScheme.surfaceContainerHighest
        //     : Theme.of(context).colorSchem0),
      ),
      // elevation: gpuCluster.companyId == ownCompanyId ? 0 : 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (viewType == GpuClusterListTileViewType.listTile)
            ListTile(
              selected: gpuCluster.companyId == ownCompanyId,
              // selectedTileColor: Theme.of(
              //   context,
              // ).colorScheme.surfaceContainerHighest,
              leading: Icon(Icons.computer),
              title: Text(gpuCluster.type.name),
              subtitle: Text("${gpuCluster.quantity}x"),
              trailing: gpuCluster.companyId == ownCompanyId
                  ? Text("Own")
                  : Text("\$999.99/hr"),
            ),
          if (viewType == GpuClusterListTileViewType.compact)
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("NVidia"),
                          Text("${gpuCluster.type.name}"),
                        ],
                      ),
                    ),

                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [Text("${gpuCluster.quantity}x")],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${gpuCluster.datacenter?.address.country.description}",
                          ),
                        ],
                      ),
                    ),

                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Row(
                    //       children: [
                    //         PropertyBadge(
                    //           text: gpuCluster.datacenter?.tier.roman ?? "",
                    //           // backgroundColor: Theme.of(
                    //           //   context,
                    //           // ).colorScheme.primaryContainer,
                    //           // foregroundColor: Theme.of(
                    //           //   context,
                    //           // ).colorScheme.onPrimaryContainer,
                    //           textStyle: Theme.of(context).textTheme.labelSmall
                    //               ?.copyWith(
                    //                 color: Theme.of(
                    //                   context,
                    //                 ).colorScheme.onPrimaryContainer,
                    //               ),
                    //         ),
                    //         SizedBox(width: 5),
                    //         Text(
                    //           "${gpuCluster.type.name} ${gpuCluster.quantity}x",
                    //           style: Theme.of(context).textTheme.titleSmall,
                    //         ),
                    //       ],
                    //     ),

                    //     if (gpuCluster.datacenter != null)
                    //       Text(
                    //         '${gpuCluster.datacenter!.name} '
                    //         '${gpuCluster.datacenter!.address.country.flagUnicode}'
                    //         ' ${gpuCluster.datacenter!.address.country.description}',
                    //         style: Theme.of(context).textTheme.labelSmall,
                    //       ),
                    //     if (gpuCluster.datacenter == null)
                    //       Text(
                    //         'Datacenter not assigned',
                    //         style: Theme.of(context).textTheme.labelSmall,
                    //       ),
                    //   ],
                    // ),
                    // FilledButton.tonal(
                    //   onPressed: gpuCluster.companyId == ownCompanyId
                    //       ? null
                    //       : () async {
                    //           await showDialog(
                    //             context: context,
                    //             builder: (context) {
                    //               return MaxWidthBox(
                    //                 maxWidth: 400,
                    //                 child: AlertDialog(
                    //                   title: Text("Launching Soon"),
                    //                   content: Text(
                    //                     "NephosX is a GPU cluster rental platform."
                    //                     " We are currently in our beta phase "
                    //                     "and we will be launching soon.",
                    //                   ),
                    //                   actions: [
                    //                     FilledButton(
                    //                       onPressed: () => Navigator.pop(context),
                    //                       child: Text("OK"),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               );
                    //             },
                    //           );
                    //         },
                    //   child: Text("From \$19.99/hr"),
                    // ),
                  ],
                ),
              ),
            ),
          // OccupationView(
          //   transactions: gpuCluster.transactions ?? [],
          //   fromDate: DateTime.now(),
          //   toDate: DateTime.now().add(Duration(days: 3 * 365)),
          // ),
        ],
      ),
    );
  }
}
