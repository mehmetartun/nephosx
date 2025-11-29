import 'package:flutter/material.dart';
import 'package:nephosx/model/gpu_cluster.dart';

import 'occupation_view_paint.dart';

class GpuClusterListTileView extends StatelessWidget {
  const GpuClusterListTileView({
    super.key,
    required this.gpuCluster,
    required this.ownCompanyId,
  });
  final GpuCluster gpuCluster;
  final String? ownCompanyId;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      elevation: 2,
      child: Column(
        children: [
          ListTile(
            selected: gpuCluster.companyId == ownCompanyId,
            leading: Icon(Icons.computer),
            title: Text(gpuCluster.type.name),
            subtitle: Text("${gpuCluster.quantity}x"),
          ),
          OccupationView(
            transactions: gpuCluster.transactions ?? [],
            fromDate: DateTime.now(),
            toDate: DateTime.now().add(Duration(days: 3 * 365)),
          ),
        ],
      ),
    );
  }
}
