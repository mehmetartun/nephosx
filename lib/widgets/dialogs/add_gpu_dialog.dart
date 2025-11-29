import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../model/datacenter.dart';
import '../../model/gpu.dart';

class AddGpuDialog extends StatefulWidget {
  const AddGpuDialog({Key? key, required this.onAddGpu}) : super(key: key);
  final void Function(Map<String, dynamic>) onAddGpu;

  @override
  State<AddGpuDialog> createState() => _AddGpuDialogState();
}

class _AddGpuDialogState extends State<AddGpuDialog> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GpuType? type;
  int? quantity;
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
                DropdownButtonFormField<GpuType>(
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
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      formKey.currentState!.save();
                      widget.onAddGpu({
                        "type": type!.name,
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
