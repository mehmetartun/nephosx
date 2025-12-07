import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class CheckboxFormField extends FormField<bool> {
  CheckboxFormField({
    super.key,
    required Widget title,
    super.onSaved,
    super.validator,
    bool super.initialValue = false,
    bool autovalidate = false,
  }) : super(
         autovalidateMode: autovalidate
             ? AutovalidateMode.always
             : AutovalidateMode.disabled,
         builder: (FormFieldState<bool> state) {
           return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               CheckboxListTile(
                 dense: true, // Makes it compact to fit in forms better
                 contentPadding:
                     EdgeInsets.zero, // Removes default tile padding
                 title: title,
                 value: state.value,
                 onChanged: state.didChange, // Updates the FormField state
                 controlAffinity:
                     ListTileControlAffinity.leading, // Checkbox on left
                 // If there is an error, we can change the text color to red
                 subtitle: state.hasError
                     ? Builder(
                         builder: (context) => Text(
                           state.errorText!,
                           style: TextStyle(
                             color: Theme.of(context).colorScheme.error,
                             fontSize: 12,
                           ),
                         ),
                       )
                     : null,
               ),
             ],
           );
         },
       );
}
