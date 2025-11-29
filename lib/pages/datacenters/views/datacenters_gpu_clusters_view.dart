import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../model/company.dart';
import '../../../model/datacenter.dart';
import '../../../model/gpu_cluster.dart';
import '../../../model/gpu_transaction.dart';
import '../../../widgets/company_list_tile.dart';
import '../../../widgets/datacenter_list_tile.dart';
import '../../../widgets/dialogs/add_company_dialog.dart';
import '../../../widgets/dialogs/add_datacenter_dialog.dart';
import '../../../widgets/dialogs/add_gpu_cluster_dialog.dart';
import '../../../widgets/gpu_cluster_list_tile.dart';

class DatacentersGpuClustersView extends StatelessWidget {
  const DatacentersGpuClustersView({
    super.key,
    required this.gpuClusters,
    required this.addGpuCluster,
    required this.updateGpuCluster,
    required this.datacenter,
    required this.backToDatacenters,
    required this.buyers,
    required this.addTransaction,
    required this.validator,
  });
  final List<GpuCluster> gpuClusters;
  final void Function(Map<String, dynamic>, Datacenter) addGpuCluster;
  final void Function(GpuCluster, Datacenter) updateGpuCluster;
  final Datacenter datacenter;
  final void Function() backToDatacenters;
  final List<Company> buyers;
  final void Function(GpuTransaction) addTransaction;
  final String? Function(GpuCluster, DateTime, DateTime) validator;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: MaxWidthBox(
          alignment: Alignment.topLeft,
          maxWidth: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                icon: Icon(Icons.arrow_back),
                label: Text("Back to Datacenters"),
                onPressed: backToDatacenters,
              ),
              Text(
                datacenter.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              Text(
                "${datacenter.region}, ${datacenter.country}",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Gpu Clusters",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  FilledButton.tonalIcon(
                    icon: Icon(Icons.add),
                    label: Text("Add"),
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return AddGpuClusterDialog(
                            onAddGpuCluster: (Map<String, dynamic> data) {
                              addGpuCluster(data, datacenter);
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              Text(
                "Click on Cluster to add transactions",
                style: Theme.of(context).textTheme.labelMedium,
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(height: 10),
                  itemCount: gpuClusters.length,
                  itemBuilder: (context, index) {
                    final gpuCluster = gpuClusters[index];
                    return GpuClusterListTile(
                      validator: validator,
                      datacenter: datacenter,
                      gpuCluster: gpuCluster,
                      onUpdateGpuCluster: (gpuCluster) {
                        updateGpuCluster(gpuCluster, datacenter);
                      },
                      buyers: buyers,
                      addTransaction: addTransaction,
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
