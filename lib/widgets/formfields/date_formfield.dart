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
    void Function()? onClear,
    bool readOnly = false,
    Widget? trailing,
    bool clearButton = false,
    bool isUtc = true,
    // Date Picker Constraints
    DateTime? firstDate,
    DateTime? lastDate,
    InputBorder? border,

    // Style options
    IconData? icon = Icons.calendar_today,
    DateFormat? dateFormat, // Optional: Pass a specific format
  }) : super(
         builder: (FormFieldState<DateTime> state) {
           return _DateTimeTextField(
             state: state,
             labelText: labelText,
             onChanged: onChanged,
             onClear: onClear,
             readOnly: readOnly,
             clearButton: clearButton,
             isUtc: isUtc,
             firstDate: firstDate,
             lastDate: lastDate,
             border: border,
             icon: icon,
             dateFormat: dateFormat,
           );
         },
       );
}

class _DateTimeTextField extends StatefulWidget {
  final FormFieldState<DateTime> state;
  final String labelText;
  final void Function(DateTime)? onChanged;
  final void Function()? onClear;
  final bool readOnly;
  final bool clearButton;
  final bool isUtc;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final InputBorder? border;
  final IconData? icon;
  final DateFormat? dateFormat;

  const _DateTimeTextField({
    required this.state,
    required this.labelText,
    this.onChanged,
    this.onClear,
    required this.readOnly,
    required this.clearButton,
    required this.isUtc,
    this.firstDate,
    this.lastDate,
    this.border,
    this.icon,
    this.dateFormat,
  });

  @override
  State<_DateTimeTextField> createState() => _DateTimeTextFieldState();
}

class _DateTimeTextFieldState extends State<_DateTimeTextField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _updateText();
  }

  @override
  void didUpdateWidget(covariant _DateTimeTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Always check if text needs update
    _updateText();
    // Note: We don't check oldWidget.state.value vs widget.state.value because
    // passing the value by reference might not show changes if mutability involved,
    // though here DateTime is immutable.
    // Ideally: if (oldWidget.state.value != widget.state.value) _updateText();
    // safely calling _updateText() is acceptable for this text field.
  }

  void _updateText() {
    String newText = '';
    if (widget.state.value != null) {
      if (widget.dateFormat != null) {
        newText = widget.dateFormat!.format(widget.state.value!);
      } else {
        newText = DateFormat("dd MMM yyyy").format(widget.state.value!);
      }
    }

    if (_controller.text != newText) {
      _controller.text = newText;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    if (widget.readOnly) return;

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.state.value ?? DateTime.now(),
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime(2100),
    );

    if (picked != null) {
      if (widget.isUtc) {
        picked = DateTime.utc(picked.year, picked.month, picked.day);
      }
      widget.state.didChange(picked); // Update the FormField state
      widget.onChanged?.call(picked);
      _updateText();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      readOnly: true,
      onTap: () => _pickDate(context),
      decoration: InputDecoration(
        border: widget.border,

        // suffix: widget.clearButton
        //     ? IconButton(
        //         visualDensity: VisualDensity.compact,
        //         icon: Icon(Icons.close),
        //         onPressed: () {
        //           widget.state.didChange(null);
        //           widget.onClear?.call();
        //           _updateText();
        //         },
        //       )
        //     : null,
        prefixIcon: Icon(widget.icon),
        suffixIcon: widget.clearButton
            ? InkWell(
                onTap: () {
                  widget.state.didChange(null);
                  widget.onClear?.call();
                  _updateText();
                },
                child: Icon(Icons.close),
              )
            : null,
        labelText: widget.isUtc
            ? "${widget.labelText} (UTC)"
            : widget.labelText,

        errorText: widget.state.errorText,
      ),
    );
  }
}
