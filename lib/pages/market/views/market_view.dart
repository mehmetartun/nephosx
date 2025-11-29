import 'package:flutter/material.dart';

import '../../../model/gpu_cluster.dart';
import '../../../widgets/gpu_cluster_list_tile_view.dart';

class MarketView extends StatelessWidget {
  const MarketView({Key? key, required this.gpuClusters, this.ownCompanyId})
    : super(key: key);
  final List<GpuCluster> gpuClusters;
  final String? ownCompanyId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(20.0),
            sliver: SliverList.builder(
              itemBuilder: (context, index) {
                return GpuClusterListTileView(
                  gpuCluster: gpuClusters[index],
                  ownCompanyId: ownCompanyId,
                );
              },
              itemCount: gpuClusters.length,
            ),
          ),
        ],
      ),
    );
  }
}
