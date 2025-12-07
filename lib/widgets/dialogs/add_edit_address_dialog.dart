import 'package:flutter/material.dart';
import 'package:nephosx/widgets/formfields/address_form_field.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../model/address.dart';
import '../../model/company.dart';
import '../../model/enums.dart';
import '../../services/platform_settings/platform_settings_service.dart';
import '../formfields/address_form_field_new.dart';

class AddEditAddressDialog extends StatefulWidget {
  const AddEditAddressDialog({
    Key? key,
    this.onAddAddress,
    this.onUpdateAddress,
    this.address,
  }) : super(key: key);
  final void Function(Address)? onAddAddress;
  final void Function(Address)? onUpdateAddress;
  final Address? address;

  @override
  State<AddEditAddressDialog> createState() => _AddEditAddressDialogState();
}

class _AddEditAddressDialogState extends State<AddEditAddressDialog> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Address? _address;

  @override
  void initState() {
    _address = widget.address;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: MaxWidthBox(
        maxWidth: 700,
        child: Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.address == null)
                  Text(
                    "Add Address",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                if (widget.address != null)
                  Text(
                    "Update Address",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                SizedBox(height: 20),
                AddressFormFieldNew(
                  initialValue: _address,
                  onSaved: (address) {
                    _address = address;
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
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FilledButton(
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            formKey.currentState!.save();
                            if (widget.address == null) {
                              widget.onAddAddress!(_address!);
                            } else {
                              widget.onUpdateAddress!(_address!);
                            }
                            Navigator.pop(context);
                          }
                        },
                        child: Text("Save"),
                      ),
                      SizedBox(width: 20),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel"),
                      ),
                    ],
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
