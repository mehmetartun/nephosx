import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../model/datacenter.dart';

class EditDatacenterDialog extends StatefulWidget {
  const EditDatacenterDialog({
    Key? key,
    required this.onUpdateDatacenter,
    required this.datacenter,
  }) : super(key: key);
  final void Function(Datacenter) onUpdateDatacenter;
  final Datacenter datacenter;

  @override
  State<EditDatacenterDialog> createState() => _EditDatacenterDialogState();
}

class _EditDatacenterDialogState extends State<EditDatacenterDialog> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String name;
  late DatacenterTier tier;
  late String country;
  late String region;
  @override
  void initState() {
    super.initState();
    name = widget.datacenter.name;
    tier = widget.datacenter.tier;
    country = widget.datacenter.country;
    region = widget.datacenter.region;
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
                Text("Update Datacenter"),
                SizedBox(height: 20),
                TextFormField(
                  autocorrect: false,
                  decoration: InputDecoration(labelText: "Name"),
                  initialValue: name,
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
                TextFormField(
                  autocorrect: false,
                  decoration: InputDecoration(labelText: "Region"),
                  initialValue: region,
                  onSaved: (value) {
                    region = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a datacenter region";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  autocorrect: false,
                  decoration: InputDecoration(labelText: "Country"),
                  initialValue: country,
                  onSaved: (value) {
                    country = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a datacenter country";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<DatacenterTier>(
                  initialValue: tier,
                  onChanged: (value) {
                    tier = value!;
                  },
                  items: DatacenterTier.values.map((tier) {
                    return DropdownMenuItem(
                      value: tier,
                      child: Text("${tier.title} (${tier.description})"),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        formKey.currentState!.save();
                        widget.onUpdateDatacenter(
                          widget.datacenter.copyWith(
                            name: name,
                            region: region,
                            country: country,
                            tier: tier,
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
