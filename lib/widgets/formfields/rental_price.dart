import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../extensions/capitalize.dart';
import '../../model/consideration.dart';
import '../../model/enums.dart';
import '../../model/rental_price.dart';
import '../../services/responsive_utils.dart';

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
  int? numberOfMonths;
  double? priceInUsdPerHour;
  @override
  void initState() {
    super.initState();
    value = widget.state.value;
    numberOfMonths = value?.numberOfMonths;
    priceInUsdPerHour = value?.priceInUsdPerHour;
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
            initialValue: numberOfMonths,
            onSaved: (val) {
              numberOfMonths = val;
            },
            onChanged: (val) {
              setState(() {
                numberOfMonths = val;
                if (numberOfMonths != null && priceInUsdPerHour != null) {
                  widget.state.didChange(
                    RentalPrice(
                      numberOfMonths: numberOfMonths!,
                      priceInUsdPerHour: priceInUsdPerHour!,
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
          width: 150,
          child: TextFormField(
            decoration: InputDecoration(labelText: "USD per hour"),
            keyboardType: TextInputType.number,
            initialValue: priceInUsdPerHour?.toString(),
            onSaved: (val) {
              priceInUsdPerHour = double.tryParse(val!);
            },
            onChanged: (val) {
              setState(() {
                priceInUsdPerHour = double.tryParse(val);
                if (numberOfMonths != null && priceInUsdPerHour != null) {
                  widget.state.didChange(
                    RentalPrice(
                      numberOfMonths: numberOfMonths!,
                      priceInUsdPerHour: priceInUsdPerHour!,
                    ),
                  );
                }
              });
            },
            validator: (val) {
              if (val == null || val.isEmpty) {
                return "Please enter an amount";
              }
              if (double.tryParse(val) == null) {
                return "Please enter a valid amount";
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
