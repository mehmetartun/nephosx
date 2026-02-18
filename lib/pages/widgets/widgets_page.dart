import 'package:flutter/material.dart';

import '../../model/gpu_cluster.dart';
import '../../widgets/gpu_cluster_stacked_card.dart';

class WidgetsPage extends StatelessWidget {
  const WidgetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Widgets")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text("GPU Cluster Stacked Card - not owner"),
              Container(
                width: 400,
                child: GpuClusterStackedCard(gpuCluster: GpuCluster.mock),
              ),
              SizedBox(height: 20),
              Text("GPU Cluster Stacked Card - owner"),
              Container(
                width: 400,
                child: GpuClusterStackedCard(
                  gpuCluster: GpuCluster.mock,
                  isOwner: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
