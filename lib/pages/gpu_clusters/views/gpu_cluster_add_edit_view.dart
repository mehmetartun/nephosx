import 'package:flutter/material.dart';

import '../../../model/datacenter.dart';
import '../../../model/gpu_cluster.dart';

class GpuClusterAddEditView extends StatefulWidget {
  final GpuCluster? gpuCluster;
  final List<Datacenter> datacenters;
  final void Function(GpuCluster) onAddGpuCluster;

  const GpuClusterAddEditView({
    super.key,
    this.gpuCluster,
    required this.datacenters,
    required this.onAddGpuCluster,
  });

  @override
  State<GpuClusterAddEditView> createState() => _GpuClusterAddEditViewState();
}

class _GpuClusterAddEditViewState extends State<GpuClusterAddEditView> {
  GpuType? type;
  int? quantity;
  Datacenter? datacenter;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    type = widget.gpuCluster?.type;
    quantity = widget.gpuCluster?.quantity;
    datacenter = widget.gpuCluster?.datacenter;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Column(
          children: [
            DropdownButtonFormField<GpuType>(
              onChanged: (value) {
                setState(() {
                  type = value!;
                });
              },
              initialValue: type,
              validator: (value) {
                if (value == null) {
                  return "Please select a GPU type";
                }
                return null;
              },
              items: GpuType.values.map((type) {
                return DropdownMenuItem(value: type, child: Text(type.name));
              }).toList(),
            ),
            TextFormField(
              autocorrect: false,
              initialValue: quantity?.toString(),
              decoration: InputDecoration(labelText: "Quantity"),
              onSaved: (value) {
                quantity = int.tryParse(value!);
                print(value);
                print(quantity);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a quantity";
                }
                if (int.tryParse(value) == null) {
                  return "Please enter a valid quantity";
                }
                return null;
              },
            ),
            DropdownButtonFormField<Datacenter>(
              initialValue: datacenter,
              onChanged: (value) {
                setState(() {
                  datacenter = value!;
                });
              },
              validator: (value) {
                if (value == null) {
                  return "Please select a GPU type";
                }
                return null;
              },
              items: widget.datacenters.map((datacenter) {
                return DropdownMenuItem(
                  value: datacenter,
                  child: Text(datacenter.name),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  formKey.currentState!.save();
                  widget.onAddGpuCluster(
                    GpuCluster(
                      type: type!,
                      quantity: quantity!,
                      datacenterId: datacenter!.id,
                      companyId: datacenter!.companyId,
                      id: widget.gpuCluster?.id ?? "",
                    ),
                  );
                }
              },
              child: Text("Add Gpu"),
            ),
          ],
        ),
      ),
    );
  }
}
