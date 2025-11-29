import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../model/company.dart';
import '../../../model/datacenter.dart';
import '../../../model/gpu.dart';
import '../../../widgets/company_list_tile.dart';
import '../../../widgets/datacenter_list_tile.dart';
import '../../../widgets/dialogs/add_company_dialog.dart';
import '../../../widgets/dialogs/add_datacenter_dialog.dart';
import '../../../widgets/dialogs/add_gpu_dialog.dart';
import '../../../widgets/gpu_list_tile.dart';

class DatacentersGpusView extends StatelessWidget {
  const DatacentersGpusView({
    super.key,
    required this.gpus,
    required this.addGpu,
    required this.updateGpu,
    required this.datacenter,
    required this.backToDatacenters,
  });
  final List<Gpu> gpus;
  final void Function(Map<String, dynamic>, Datacenter) addGpu;
  final void Function(Gpu, Datacenter) updateGpu;
  final Datacenter datacenter;
  final void Function() backToDatacenters;

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
                    "Gpus",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  FilledButton.tonalIcon(
                    icon: Icon(Icons.add),
                    label: Text("Add"),
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return AddGpuDialog(
                            onAddGpu: (Map<String, dynamic> data) {
                              addGpu(data, datacenter);
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  children: gpus
                      .map(
                        (gpu) => GpuListTile(
                          gpu: gpu,
                          onUpdateGpu: (gpu) {
                            updateGpu(gpu, datacenter);
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
