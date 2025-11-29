import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../extensions/capitalize.dart';
import '../../model/consideration.dart';
import '../../model/enums.dart';
import '../../services/responsive_utils.dart';

class ConsiderationFormField extends FormField<Consideration> {
  ConsiderationFormField({
    super.key,
    super.validator,
    super.onSaved,
    super.initialValue,
  }) : super(
         builder: (state) {
           return _ConsiderationFormField(state: state);
         },
       );
}

class _ConsiderationFormField extends StatefulWidget {
  const _ConsiderationFormField({required this.state});
  final FormFieldState<Consideration> state;

  @override
  State<_ConsiderationFormField> createState() =>
      __ConsiderationFormFieldState();
}

class __ConsiderationFormFieldState extends State<_ConsiderationFormField> {
  Consideration? value;
  Currency? currency;
  double? amount;
  @override
  void initState() {
    super.initState();
    value = widget.state.value;
    currency = value?.currency;
    amount = value?.amount;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Currency", style: Theme.of(context).textTheme.labelMedium),
              SizedBox(height: 10),
              DropdownButtonFormField<Currency>(
                initialValue: currency,
                onSaved: (val) {
                  currency = val;
                },
                onChanged: (val) {
                  setState(() {
                    currency = val;
                    if (currency != null && amount != null) {
                      widget.state.didChange(
                        Consideration(currency: currency!, amount: amount!),
                      );
                    }
                  });
                },
                validator: (val) {
                  if (val == null) {
                    return "Please select a currency";
                  }
                  return null;
                },
                items: Currency.values.map((e) {
                  return DropdownMenuItem(value: e, child: Text(e.title));
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Amount", style: Theme.of(context).textTheme.labelMedium),
              SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.number,
                initialValue: amount?.toString(),
                onSaved: (val) {
                  amount = double.tryParse(val!);
                },
                onChanged: (val) {
                  setState(() {
                    amount = double.tryParse(val);
                    if (currency != null && amount != null) {
                      widget.state.didChange(
                        Consideration(currency: currency!, amount: amount!),
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
            ],
          ),
        ),
      ],
    );
  }
}
