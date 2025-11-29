import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../model/datacenter.dart';

class AddDatacenterDialog extends StatefulWidget {
  const AddDatacenterDialog({Key? key, required this.onAddDatacenter})
    : super(key: key);
  final void Function(Map<String, dynamic>) onAddDatacenter;

  @override
  State<AddDatacenterDialog> createState() => _AddDatacenterDialogState();
}

class _AddDatacenterDialogState extends State<AddDatacenterDialog> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String name = "";
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
                TextFormField(
                  autocorrect: false,
                  decoration: InputDecoration(labelText: "Datacenter Name"),
                  onSaved: (value) {
                    name = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a datacenter name";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      formKey.currentState!.save();
                      widget.onAddDatacenter({
                        "name": name,
                        "tier": DatacenterTier.tier1.name,
                        "country": "Sweden",
                        "region": "Northern Europe",
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Text("Add Datacenter"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
