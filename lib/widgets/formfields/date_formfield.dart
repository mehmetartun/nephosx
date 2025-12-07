import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Recommended for formatting, see note below

class DateTimeFormField extends FormField<DateTime> {
  DateTimeFormField({
    super.key,
    required String labelText,
    super.onSaved,
    super.validator,
    super.initialValue,
    super.autovalidateMode,
    void Function(DateTime)? onChanged,
    bool readOnly = false,

    // Date Picker Constraints
    DateTime? firstDate,
    DateTime? lastDate,

    // Style options
    IconData? icon = Icons.calendar_today,
    DateFormat? dateFormat, // Optional: Pass a specific format
  }) : super(
         builder: (FormFieldState<DateTime> state) {
           // Helper to handle the click
           Future<void> pickDate(BuildContext context) async {
             final DateTime? picked = await showDatePicker(
               context: context,
               initialDate: state.value ?? DateTime.now(),
               firstDate: firstDate ?? DateTime(1900),
               lastDate: lastDate ?? DateTime(2100),
             );

             if (picked != null) {
               state.didChange(picked); // Update the FormField state
               onChanged?.call(picked);
             }
           }

           // Define how the date is displayed as text
           String textValue = '';
           if (state.value != null) {
             // If you have intl package: dateFormat?.format(state.value!)
             // Otherwise simple fallback:
             textValue = DateFormat("dd MMM yyyy").format(state.value!);
             //  "${state.value!.month}/${state.value!.day}/${state.value!.year}";
           }

           return InkWell(
             onTap: readOnly ? null : () => pickDate(state.context),
             child: InputDecorator(
               // isEmpty: true ensures the label sits inside the box when null
               // isEmpty: false ensures the label floats above when has value
               isEmpty: state.value == null,

               decoration: InputDecoration(
                 labelText: labelText,
                 prefixIcon: Icon(icon),
                 errorText: state.errorText, // Standard Form error display
                 //  border: const OutlineInputBorder(), // Matches TextFormField
               ),

               // This is the actual text displayed inside the box
               child: Text(
                 textValue,
                 style: Theme.of(state.context).textTheme.bodyLarge,
               ),
             ),
           );
         },
       );
}
