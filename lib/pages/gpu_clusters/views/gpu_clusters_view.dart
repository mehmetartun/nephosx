import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../blocs/authentication/authentication_bloc.dart';
import '../../../model/enums.dart';
import '../../../model/gpu_cluster.dart';
import '../../../services/csv/csv_service.dart';
import '../../../widgets/gpu_cluster_list_tile.dart';
import '../../../widgets/property_badge.dart';

class GpuClustersView extends StatelessWidget {
  const GpuClustersView({
    Key? key,
    required this.gpuClusters,
    required this.addGpuClusterRequest,
    required this.updateGpuClusterRequest,
  }) : super(key: key);
  final List<GpuCluster> gpuClusters;
  final void Function(GpuCluster) updateGpuClusterRequest;
  final void Function() addGpuClusterRequest;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: MaxWidthBox(
          alignment: Alignment.topCenter,
          maxWidth: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "GPU Clusters",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (BlocProvider.of<AuthenticationBloc>(
                            context,
                          ).user?.canSeeGpuClusters ??
                          false)
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: OutlinedButton.icon(
                            icon: Icon(Icons.add),
                            label: Text("Add"),
                            onPressed: addGpuClusterRequest,
                          ),
                        ),
                      if (BlocProvider.of<AuthenticationBloc>(
                            context,
                          ).user?.canSeeGpuClusters ??
                          false)
                        OutlinedButton.icon(
                          icon: Icon(Icons.download),
                          label: Text("Export"),
                          onPressed: () async {
                            await CsvService().exportGpuClusters(gpuClusters);
                          },
                        ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) =>
                      const Divider(height: 10),
                  itemCount: gpuClusters.length,
                  itemBuilder: (context, index) {
                    final gpuCluster = gpuClusters[index];
                    return ListTile(
                      leading: Icon(Icons.computer),
                      title: Text(
                        "${gpuCluster.device?.name ?? 'ERROR'} ${gpuCluster.quantity}x",
                      ),
                      subtitle: Row(
                        children: [
                          PropertyBadge(
                            text: gpuCluster.datacenter?.tier.roman ?? "",
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                            textStyle: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                ),
                          ),
                          SizedBox(width: 10),
                          Text(gpuCluster.datacenter?.name ?? ""),
                          SizedBox(width: 10),
                          Text(
                            gpuCluster
                                    .datacenter
                                    ?.address
                                    .country
                                    .flagUnicode ??
                                "",
                          ),
                          SizedBox(width: 2),
                          Text(
                            gpuCluster
                                    .datacenter
                                    ?.address
                                    .country
                                    .description ??
                                "",
                          ),
                        ],
                      ),
                      trailing:
                          (BlocProvider.of<AuthenticationBloc>(
                                context,
                              ).user?.canUpdateGpuCluster ??
                              false)
                          ? IconButton(
                              onPressed: () =>
                                  updateGpuClusterRequest(gpuCluster),
                              icon: Icon(Icons.edit),
                            )
                          : SizedBox.shrink(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
