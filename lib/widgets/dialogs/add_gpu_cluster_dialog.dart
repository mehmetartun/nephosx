import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../constants.dart';

class AddGpuClusterDialog extends StatefulWidget {
  const AddGpuClusterDialog({Key? key, required this.onAddGpuCluster})
    : super(key: key);
  final void Function(Map<String, dynamic>) onAddGpuCluster;

  @override
  State<AddGpuClusterDialog> createState() => _AddGpuClusterDialogState();
}

class _AddGpuClusterDialogState extends State<AddGpuClusterDialog> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  int? quantity;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: MaxWidthBox(
        maxWidth: 500,
        child: Dialog(
          child: Padding(
            padding: kColumnPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // DropdownButtonFormField<GpuType>(
                //   onChanged: (value) {
                //     setState(() {
                //       type = value!;
                //     });
                //   },
                //   validator: (value) {
                //     if (value == null) {
                //       return "Please select a GPU type";
                //     }
                //     return null;
                //   },
                //   items: GpuType.values.map((type) {
                //     return DropdownMenuItem(
                //       value: type,
                //       child: Text(type.name),
                //     );
                //   }).toList(),
                // ),
                TextFormField(
                  autocorrect: false,
                  decoration: InputDecoration(labelText: "Quantity"),
                  onSaved: (value) {
                    quantity = int.tryParse(value!);
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
                SizedBox(height: 20),
                FilledButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      formKey.currentState!.save();
                      widget.onAddGpuCluster({
                        // "type": type!.name,
                        "quantity": quantity,
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Text("Add Gpu"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
