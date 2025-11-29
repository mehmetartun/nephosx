import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../model/datacenter.dart';
import '../../model/gpu_cluster.dart';

class EditGpuClusterDialog extends StatefulWidget {
  const EditGpuClusterDialog({
    Key? key,
    required this.onUpdateGpuCluster,
    required this.gpuCluster,
  }) : super(key: key);
  final void Function(GpuCluster) onUpdateGpuCluster;
  final GpuCluster gpuCluster;

  @override
  State<EditGpuClusterDialog> createState() => _EditGpuClusterDialogState();
}

class _EditGpuClusterDialogState extends State<EditGpuClusterDialog> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late int quantity;
  late GpuType type;
  @override
  void initState() {
    super.initState();
    type = widget.gpuCluster.type;
    quantity = widget.gpuCluster.quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: MaxWidthBox(
        maxWidth: 500,
        child: Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Update GPU"),
                SizedBox(height: 20),
                DropdownButtonFormField<GpuType>(
                  initialValue: type,
                  onChanged: (value) {
                    setState(() {
                      type = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return "Please select a GPU type";
                    }
                    return null;
                  },
                  items: GpuType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.name),
                    );
                  }).toList(),
                ),
                TextFormField(
                  autocorrect: false,
                  initialValue: quantity.toString(),
                  decoration: InputDecoration(labelText: "Quantity"),
                  onSaved: (value) {
                    quantity = int.tryParse(value!)!;
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
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        formKey.currentState!.save();
                        widget.onUpdateGpuCluster(
                          widget.gpuCluster.copyWith(
                            type: type,
                            quantity: quantity,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: Text("Update"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
