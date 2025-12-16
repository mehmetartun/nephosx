import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../extensions/capitalize.dart';
import '../../model/consideration.dart';
import '../../model/enums.dart';
import '../../model/rental_price.dart';
import '../../services/responsive_utils.dart';
import 'consideration_form_field.dart';

class RentalPriceFormField extends FormField<RentalPrice> {
  RentalPriceFormField({
    super.key,
    super.validator,
    super.onSaved,
    super.initialValue,
  }) : super(
         builder: (state) {
           return _RentalPriceFormField(state: state);
         },
       );
}

class _RentalPriceFormField extends StatefulWidget {
  const _RentalPriceFormField({required this.state});
  final FormFieldState<RentalPrice> state;

  @override
  State<_RentalPriceFormField> createState() => __RentalPriceFormFieldState();
}

class __RentalPriceFormFieldState extends State<_RentalPriceFormField> {
  RentalPrice? value;
  int? numberOfUnits;
  Consideration? pricePerHour;
  RentalPriceType rentalPriceType = RentalPriceType.monthly;

  @override
  void initState() {
    super.initState();
    value = widget.state.value;
    numberOfUnits = value?.numberOfUnits;
    pricePerHour = value?.pricePerHour;
    rentalPriceType = value?.rentalPriceType ?? RentalPriceType.monthly;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 200,
          child: DropdownButtonFormField<int>(
            decoration: InputDecoration(
              border: InputBorder.none,
              labelText: "Duration",
            ),
            initialValue: numberOfUnits,
            onSaved: (val) {
              numberOfUnits = val;
            },
            onChanged: (val) {
              setState(() {
                numberOfUnits = val;
                if (numberOfUnits != null &&
                    pricePerHour != null &&
                    rentalPriceType != null) {
                  widget.state.didChange(
                    RentalPrice(
                      numberOfUnits: numberOfUnits!,
                      pricePerHour: pricePerHour!,
                      rentalPriceType: rentalPriceType!,
                    ),
                  );
                }
              });
            },
            validator: (val) {
              if (val == null) {
                return "Please select a duration";
              }
              return null;
            },
            items: [1, 3, 6, 12].map((e) {
              return DropdownMenuItem(value: e, child: Text("$e months"));
            }).toList(),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 400,
          child: ConsiderationFormField(
            // decoration: InputDecoration(labelText: "USD per hour"),
            // keyboardType: TextInputType.number,
            initialValue: pricePerHour,
            onSaved: (val) {
              pricePerHour = val;
            },
            onChanged: (val) {
              setState(() {
                pricePerHour = val;
                if (numberOfUnits != null &&
                    pricePerHour != null &&
                    rentalPriceType != null) {
                  widget.state.didChange(
                    RentalPrice(
                      numberOfUnits: numberOfUnits!,
                      pricePerHour: pricePerHour!,
                      rentalPriceType: rentalPriceType!,
                    ),
                  );
                }
              });
            },
            validator: (val) {
              if (val == null) {
                return "Please enter an amount";
              }

              return null;
            },
          ),
        ),
      ],
    );
  }
}
