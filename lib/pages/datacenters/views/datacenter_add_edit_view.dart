import 'package:flutter/material.dart';
import 'package:nephosx/extensions/capitalize.dart';
import 'package:nephosx/pages/datacenters/views/datacenters_view.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../model/address.dart';
import '../../../model/company.dart';
import '../../../model/datacenter.dart';
import '../../../widgets/company_list_tile.dart';
import '../../../widgets/datacenter_list_tile.dart';
import '../../../widgets/dialogs/add_edit_address_dialog.dart';
import '../../../widgets/dialogs/add_edit_company_dialog.dart';
import '../../../widgets/dialogs/add_edit_datacenter_dialog.dart';
import '../../../widgets/formfields/check_box_form_field.dart';

class DatacenterAddEditView extends StatefulWidget {
  const DatacenterAddEditView({
    super.key,

    required this.addDatacenter,
    required this.updateDatacenter,
    required this.backToDatacenters,
    this.datacenter,
    required this.companyId,
  });

  final void Function(Datacenter) addDatacenter;
  final void Function(Datacenter) updateDatacenter;
  final void Function() backToDatacenters;
  final Datacenter? datacenter;
  final String companyId;

  @override
  State<DatacenterAddEditView> createState() => _DatacenterAddEditViewState();
}

enum DatacenterSort { name, tier, country }

class _DatacenterAddEditViewState extends State<DatacenterAddEditView> {
  String? name;
  DatacenterTier? tier;
  Address? address;
  late String companyId;
  String? id;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? addressError;
  late bool iso27001;
  @override
  void initState() {
    super.initState();
    companyId = widget.companyId;
    name = widget.datacenter?.name;
    tier = widget.datacenter?.tier;
    address = widget.datacenter?.address;
    id = widget.datacenter?.id;
    iso27001 = widget.datacenter?.iso27001 ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: MaxWidthBox(
          alignment: Alignment.topCenter,
          maxWidth: 500,
          child: Form(
            key: formKey,
            child: MaxWidthBox(
              maxWidth: 500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton.icon(
                    icon: Icon(Icons.arrow_back),
                    label: Text("Back"),
                    onPressed: widget.backToDatacenters,
                  ),
                  Text(
                    'Datacenter',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    autocorrect: false,
                    initialValue: name,
                    decoration: InputDecoration(
                      labelText: "Datacenter Name",
                      filled: true,
                    ),
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
                    initialValue: tier,
                    decoration: InputDecoration(
                      labelText: "Datacenter Tier",
                      filled: true,
                    ),
                    items: DatacenterTier.values.map((tier) {
                      return DropdownMenuItem(
                        value: tier,
                        child: Text(tier.roman),
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
                  SizedBox(height: 20),
                  CheckboxFormField(
                    initialValue: iso27001,
                    onSaved: (value) {
                      iso27001 = value ?? false;
                    },
                    title: Text("ISO 27001"),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Address',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  address == null
                      ? TextButton.icon(
                          label: Text("Add Address"),
                          icon: const Icon(Icons.add),
                          onPressed: () async {
                            await showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => MaxWidthBox(
                                maxWidth: 700,
                                child: AddEditAddressDialog(
                                  onUpdateAddress: (address) {
                                    setState(() {
                                      this.address = address;
                                    });
                                  },
                                  onAddAddress: (address) {
                                    setState(() {
                                      this.address = address;
                                    });
                                  },
                                  address: address,
                                ),
                              ),
                            );
                          },
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(address!.toString()),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                await showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) => MaxWidthBox(
                                    maxWidth: 700,
                                    child: AddEditAddressDialog(
                                      onUpdateAddress: (address) {
                                        setState(() {
                                          this.address = address;
                                        });
                                      },
                                      address: address,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                  if (addressError != null)
                    Text(
                      addressError!,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),

                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        if ((formKey.currentState?.validate() ?? false) &&
                            address != null) {
                          formKey.currentState!.save();
                          widget.datacenter == null
                              ? widget.addDatacenter(
                                  Datacenter(
                                    name: name!,
                                    id: "1",
                                    address: address!,
                                    tier: tier!,
                                    companyId: companyId,
                                    iso27001: iso27001,
                                  ),
                                )
                              : widget.updateDatacenter(
                                  Datacenter(
                                    name: name!,
                                    id: widget.datacenter!.id,
                                    address: address!,
                                    tier: tier!,
                                    companyId: companyId,
                                    iso27001: iso27001,
                                  ),
                                );
                        } else {
                          if (address == null) {
                            setState(() {
                              addressError = "Please add an address";
                            });
                          }
                        }
                      },
                      child: Text(
                        widget.datacenter == null
                            ? "Add Datacenter"
                            : "Update Datacenter",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
