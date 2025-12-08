import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../extensions/capitalize.dart';
import '../../model/address.dart';
import '../../model/consideration.dart';
import '../../model/enums.dart';
import '../../services/responsive_utils.dart';

class AddressFormFieldNew extends FormField<Address> {
  AddressFormFieldNew({
    super.key,
    super.validator,
    super.onSaved,
    super.initialValue,
    // this.onChanged,
    required this.allowedCountries,
    required this.favoriteCountries,
  }) : super(
         builder: (state) {
           return _AddressFormField(
             initialAddress: initialValue,
             onAddressChanged: (Address? address) {
               state.didChange(address);
             },
             allowedCountries: allowedCountries,
             favoriteCountries: favoriteCountries,
           );
         },
       );
  // final void Function(Address?)? onChanged;
  final List<Country> allowedCountries;
  final List<Country> favoriteCountries;
}

class _AddressFormField extends StatefulWidget {
  _AddressFormField({
    required this.onAddressChanged,
    required this.allowedCountries,
    required this.favoriteCountries,
    this.initialAddress,
  });
  final ValueChanged<Address?> onAddressChanged;
  final List<Country> allowedCountries;
  final List<Country> favoriteCountries;
  final Address? initialAddress;

  @override
  State<_AddressFormField> createState() => __AddressFormFieldState();
}

class __AddressFormFieldState extends State<_AddressFormField> {
  Address? value;

  Country? country;
  AddressState? addressState;

  late TextEditingController line1Controller;
  late TextEditingController line2Controller;
  late TextEditingController line3Controller;
  late TextEditingController cityController;
  late TextEditingController zipCodeController;
  late List<Country> _allowedCountries;
  late List<Country> _favoriteCountries;

  @override
  void initState() {
    super.initState();
    _allowedCountries = widget.allowedCountries;
    _favoriteCountries = widget.favoriteCountries;

    if (widget.initialAddress != null) {
      var country = widget.initialAddress!.country;
      if (!widget.allowedCountries.contains(country) ||
          !widget.favoriteCountries.contains(country)) {
        _favoriteCountries.add(country);
      }
    }

    _allowedCountries.removeWhere(
      (element) => _favoriteCountries.contains(element),
    );

    value = widget.initialAddress;

    line1Controller = TextEditingController(text: value?.addressLine1);
    line2Controller = TextEditingController(text: value?.addressLine2);
    line3Controller = TextEditingController(text: value?.addressLine3);
    cityController = TextEditingController(text: value?.city);
    zipCodeController = TextEditingController(text: value?.zipCode);

    country = value?.country;
    addressState = value?.state;

    line1Controller.addListener(_propagateChange);
    line2Controller.addListener(_propagateChange);
    line3Controller.addListener(_propagateChange);
    cityController.addListener(_propagateChange);
    zipCodeController.addListener(_propagateChange);
  }

  void _propagateChange() {
    if (country == null) {
      widget.onAddressChanged(null);
      return;
    }
    if (country!.hasStates && addressState == null) {
      widget.onAddressChanged(null);
      return;
    }

    // Note: We create the object even if text fields are empty so
    // the parent FormField has *some* value, but the TextFormFields
    // themselves will handle the "Required" error display.
    widget.onAddressChanged(
      Address(
        addressLine1: line1Controller.text,
        addressLine2: line2Controller.text.isEmpty
            ? null
            : line2Controller.text,
        addressLine3: line3Controller.text.isEmpty
            ? null
            : line3Controller.text,
        city: cityController.text,
        state: addressState,
        zipCode: zipCodeController.text,
        country: country!,
      ),
    );
  }

  @override
  void dispose() {
    line1Controller.dispose();
    line2Controller.dispose();
    line3Controller.dispose();
    cityController.dispose();
    zipCodeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          decoration: InputDecoration(
            filled: true,
            labelText: "Address Line 1sdsd",
          ),
          validator: (val) {
            if (val!.isEmpty) {
              return "Please enter an address line 1";
            }
            return null;
          },
          controller: line1Controller,
        ),
        SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(
            filled: true,
            labelText: "Address Line 2",
          ),
          controller: line2Controller,

          validator: (val) {
            if (val!.isEmpty && (country?.numLines ?? 1) > 1) {
              return "Please enter an address line 2";
            }
            return null;
          },
        ),
        SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(
            filled: true,
            labelText: "Address Line 3",
          ),
          controller: line3Controller,

          validator: (val) {
            if (val!.isEmpty && (country?.numLines ?? 2) > 2) {
              return "Please enter an address line 3";
            }
            return null;
          },
        ),
        SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(filled: true, labelText: "City"),
          controller: cityController,

          validator: (val) {
            if (val!.isEmpty) {
              return "Please enter a city";
            }
            return null;
          },
        ),
        SizedBox(height: 10),

        TextFormField(
          decoration: InputDecoration(filled: true, labelText: "ZipCode"),
          controller: zipCodeController,
          validator: (val) {
            if (val!.isEmpty) {
              return "Please enter a zip code";
            }
            return null;
          },
        ),
        SizedBox(height: 10),
        if (country?.hasStates ?? false) ...[
          DropdownMenuFormField<AddressState>(
            // decoration: InputDecoration(
            //   filled: true,
            //   labelText: "${country!.description} State",

            //   hintText: "Select ${country!.description} State",
            // ),
            initialSelection: addressState,
            onSelected: (val) {
              addressState = val;
              // _propagateChange
              // setState(() => addressState = val);
              // // Update the internal FormField state so validation clears
              // stateField.didChange(val);
              _propagateChange();
            },

            validator: (val) {
              if (val == null) {
                return "Please select a state";
              }
              return null;
            },
            dropdownMenuEntries: AddressState.values
                .where((st) {
                  return st.country == country!;
                })
                .toList()
                .map((e) {
                  return DropdownMenuEntry(value: e, label: "${e.description}");
                })
                .toList(),
          ),
        ],
        SizedBox(height: 10),

        Container(
          width: double.infinity,
          child: DropdownMenuFormField<Country>(
            initialSelection: country,
            dropdownMenuEntries: (_favoriteCountries + _allowedCountries)
                .mapIndexed((index, e) {
                  return DropdownMenuEntry(
                    value: e,
                    label: "${e.flagUnicode} ${e.description}",
                    style:
                        _favoriteCountries.isNotEmpty &&
                            index == _favoriteCountries.length - 1
                        ? MenuItemButton.styleFrom(
                            shape: LinearBorder.bottom(
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                          )
                        : null,
                  );
                })
                .toList(),

            onSelected: (val) {
              country = val;
              // _propagateChange
              // setState(() => addressState = val);
              // // Update the internal FormField state so validation clears
              // stateField.didChange(val);
              _propagateChange();
            },

            validator: (val) {
              if (val == null) {
                return "Please select a country";
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
