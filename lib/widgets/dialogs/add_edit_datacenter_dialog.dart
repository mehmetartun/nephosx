import 'package:flutter/material.dart';
import 'package:nephosx/model/address.dart';
import 'package:nephosx/services/mock.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../model/datacenter.dart';
import '../../model/enums.dart';
import '../../model/platform_settings.dart';
import '../../services/platform_settings/platform_settings_service.dart';
import '../formfields/address_form_field.dart';
import '../formfields/address_form_field_new.dart';

class AddEditDatacenterDialog extends StatefulWidget {
  const AddEditDatacenterDialog({
    Key? key,

    required this.onAddDatacenter,
    required this.companyId,
    required this.onUpdateDatacenter,
    this.datacenter,
  }) : super(key: key);
  final void Function(Datacenter) onAddDatacenter;
  final void Function(Datacenter) onUpdateDatacenter;
  final String companyId;
  final Datacenter? datacenter;

  @override
  State<AddEditDatacenterDialog> createState() =>
      _AddEditDatacenterDialogState();
}

class _AddEditDatacenterDialogState extends State<AddEditDatacenterDialog> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? name;
  DatacenterTier? tier;
  Address? address;
  late String companyId;
  String? id;

  @override
  void initState() {
    super.initState();
    companyId = widget.companyId;
    name = widget.datacenter?.name;
    tier = widget.datacenter?.tier;
    address = widget.datacenter?.address;
    id = widget.datacenter?.id;
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
                DropdownButtonFormField<DatacenterTier>(
                  decoration: InputDecoration(labelText: "Datacenter Tier"),
                  items: DatacenterTier.values.map((tier) {
                    return DropdownMenuItem(
                      value: tier,
                      child: Text(tier.name),
                    );
                  }).toList(),
                  onSaved: (value) {
                    tier = value!;
                  },
                  onChanged: (value) {
                    setState(() {
                      tier = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return "Please select a datacenter tier";
                    }
                    return null;
                  },
                ),
                AddressFormFieldNew(
                  initialValue: address,
                  onSaved: (value) {
                    address = value;
                  },
                  allowedCountries: PlatformSettingsService
                      .instance
                      .platformSettings
                      .datacenterRemainingCountriesList,
                  favoriteCountries: PlatformSettingsService
                      .instance
                      .platformSettings
                      .datacenterFavoriteCountriesList,
                ),

                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      formKey.currentState!.save();
                      widget.onAddDatacenter(
                        Datacenter(
                          name: name!,
                          id: "1",
                          address: Address(
                            addressLine1: "Street",
                            city: "Istanbul",
                            country: Country.gb,
                            zipCode: "12345",
                          ),
                          tier: DatacenterTier.tier1,
                          companyId: "1",
                        ),
                      );
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
