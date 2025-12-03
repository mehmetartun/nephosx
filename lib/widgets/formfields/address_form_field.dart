import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../extensions/capitalize.dart';
import '../../model/address.dart';
import '../../model/consideration.dart';
import '../../model/enums.dart';
import '../../services/responsive_utils.dart';

class AddressFormField extends FormField<Address> {
  AddressFormField({
    super.key,
    super.validator,
    super.onSaved,
    super.initialValue,
    this.onChanged,
  }) : super(
         //  validator: (value) {
         //    if (value == null) {
         //      return "Address cannot be empty";
         //    }
         //    return null;
         //  },
         builder: (state) {
           return _AddressFormField(state: state);
         },
       );
  final void Function(Address?)? onChanged;
}

class _AddressFormField extends StatefulWidget {
  const _AddressFormField({required this.state});
  final FormFieldState<Address> state;

  @override
  State<_AddressFormField> createState() => __AddressFormFieldState();
}

class __AddressFormFieldState extends State<_AddressFormField> {
  Address? value;

  Country? country;
  AddressState? state;

  late TextEditingController line1Controller;
  late TextEditingController line2Controller;
  late TextEditingController line3Controller;
  late TextEditingController cityController;
  late TextEditingController zipCodeController;

  @override
  void initState() {
    super.initState();
    value = widget.state.value;

    line1Controller = TextEditingController(text: value?.addressLine1);
    line2Controller = TextEditingController(text: value?.addressLine2);
    line3Controller = TextEditingController(text: value?.addressLine3);
    cityController = TextEditingController(text: value?.city);
    zipCodeController = TextEditingController(text: value?.zipCode);

    country = value?.country;
    state = value?.state;
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

  String? get line1Error {
    if (line1Controller.text.isEmpty) {
      return "First line of address cannot be empty";
    } else {
      return null;
    }
  }

  String? get line2Error {
    if (country != null &&
        country!.numLines > 1 &&
        line2Controller.text.isEmpty) {
      return "Second line of address cannot be empty";
    } else {
      return null;
    }
  }

  String? get line3Error {
    if (country != null &&
        country!.numLines > 2 &&
        line3Controller.text.isEmpty) {
      return "Third line of address cannot be empty";
    } else {
      return null;
    }
  }

  String? get cityError {
    if (cityController.text.isEmpty) {
      return "City cannot be empty";
    } else {
      return null;
    }
  }

  String? get zipCodeError {
    if (zipCodeController.text.isEmpty) {
      return "Zip Code cannot be empty";
    } else {
      return null;
    }
  }

  String? get countryError {
    if (country == null) {
      return "Country cannot be empty";
    } else {
      return null;
    }
  }

  String? get stateError {
    if (country != null && country!.hasStates && state == null) {
      return "State cannot be empty";
    } else {
      return null;
    }
  }

  bool addressIsValid() {
    if (country == null) {
      value = null;
      return false;
    }
    if (cityController.text.isEmpty) {
      value = null;
      return false;
    }
    if (line1Controller.text.isEmpty) {
      value = null;
      return false;
    }
    if (country!.hasStates && state == null) {
      value = null;
      return false;
    }
    if (country!.numLines == 2 && line2Controller.text.isEmpty) {
      value = null;
      return false;
    }
    if (zipCodeController.text.isEmpty) {
      value = null;
      return false;
    }
    value = Address(
      addressLine1: line1Controller.text,
      addressLine2: line2Controller.text.isEmpty ? null : line2Controller.text,
      addressLine3: line3Controller.text.isEmpty ? null : line3Controller.text,
      city: cityController.text,
      country: country!,
      state: country!.hasStates ? state : null,
      zipCode: zipCodeController.text,
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: InputDecoration(
            filled: true,
            labelText: "Address Line 1",
            errorText: widget.state.hasError ? line1Error : null,
          ),
          controller: line1Controller,
          onChanged: (val) {
            setState(() {
              if (addressIsValid()) {
                widget.state.didChange(value);
              }
            });
          },
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            filled: true,
            labelText: "Address Line 2",
            errorText: widget.state.hasError ? line2Error : null,
          ),
          controller: line2Controller,
          onChanged: (val) {
            setState(() {
              if (addressIsValid()) {
                widget.state.didChange(value);
              }
            });
          },
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            filled: true,
            labelText: "Address Line 3",
            errorText: widget.state.hasError ? line3Error : null,
          ),
          controller: line3Controller,
          onChanged: (val) {
            setState(() {
              if (addressIsValid()) {
                widget.state.didChange(value);
              }
            });
          },
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            filled: true,
            labelText: "City",
            errorText: widget.state.hasError ? cityError : null,
          ),
          controller: cityController,
          onChanged: (val) {
            setState(() {
              if (addressIsValid()) {
                widget.state.didChange(value);
              }
            });
          },
        ),
        SizedBox(height: 10),

        TextField(
          decoration: InputDecoration(
            filled: true,
            labelText: "ZipCode",
            errorText: widget.state.hasError ? zipCodeError : null,
          ),
          controller: zipCodeController,
          onChanged: (val) {
            setState(() {
              if (addressIsValid()) {
                widget.state.didChange(value);
              }
            });
          },
        ),
        SizedBox(height: 10),
        if (country?.hasStates ?? false) ...[
          DropdownButtonFormField<AddressState>(
            decoration: InputDecoration(
              filled: true,
              labelText: "${country!.description} State",
              errorText: widget.state.hasError ? countryError : null,
              hintText: "Select ${country!.description} State",
            ),
            initialValue: state,
            onChanged: (val) {
              setState(() {
                state = val;
                if (addressIsValid()) {
                  widget.state.didChange(value);
                }
              });
            },

            validator: (val) {
              if (val == null) {
                return "Please select a state";
              }
              return null;
            },
            items: AddressState.values
                .where((st) {
                  return st.country == country!;
                })
                .toList()
                .map((e) {
                  return DropdownMenuItem(value: e, child: Text(e.description));
                })
                .toList(),
          ),
        ],
        SizedBox(height: 10),

        DropdownButtonFormField<Country>(
          decoration: InputDecoration(
            filled: true,
            labelText: "Country",
            errorText: widget.state.hasError ? countryError : null,
            hintText: "Select Country",
          ),
          initialValue: country,

          onChanged: (val) {
            setState(() {
              country = val;
              if (country?.hasStates ?? false) {
                state = null;
              }
              if (country == null) {
                value = null;
              }
              if (addressIsValid()) {
                widget.state.didChange(value);
              }
            });
          },

          validator: (val) {
            if (val == null) {
              return "Please select a country";
            }
            return null;
          },
          items: Country.values.map((e) {
            return DropdownMenuItem(value: e, child: Text(e.description));
          }).toList(),
        ),
        // FilledButton(
        //   child: Text("Save"),
        //   onPressed: () {
        //     print(widget.state.value);
        //   },
        // ),
      ],
    );
  }
}
