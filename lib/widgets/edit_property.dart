import 'package:coach/extensions/capitalize.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditProperty<T> extends StatefulWidget {
  final String fieldName;
  final NumberFormat? numberFormat;
  final EdgeInsets? margin;

  final T initialValue;
  final void Function(T value, String fieldName) onUpdate;

  const EditProperty({
    super.key,
    required this.fieldName,
    required this.initialValue,
    required this.onUpdate,
    this.numberFormat,
    this.margin,
  });

  @override
  State<EditProperty<T>> createState() => _EditPropertyState<T>();
}

class _EditPropertyState<T> extends State<EditProperty<T>> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late T _value;

  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  bool isEditing = false;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
    _controller.text = _value.toString();
    _controller2.text = _value.toString();
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
    focusNode.dispose();
    super.dispose();
  }

  String getDisplayString(T val) {
    if (widget.numberFormat != null && _value is num) {
      return widget.numberFormat!.format(_value);
    } else {
      return _value.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(10),
          margin: widget.margin ?? EdgeInsets.fromLTRB(0, 10, 0, 10),

          decoration: ShapeDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),

          // Constrain width of the form field
          child: TextFormField(
            controller: _controller,
            onTapOutside: (event) {
              focusNode.unfocus();
              _controller.text = _controller2.text;
              setState(() {
                isEditing = false;
              });
            },
            // autofocus: true,
            onFieldSubmitted: (value) {
              if (value != null) {
                T? parsedValue;
                if (T == int) {
                  parsedValue = int.tryParse(value) as T?;
                } else if (T == double) {
                  parsedValue = double.tryParse(value) as T?;
                } else {
                  parsedValue = value as T?;
                }
                if (parsedValue != null) {
                  widget.onUpdate(parsedValue, widget.fieldName);
                  _value = parsedValue;

                  setState(() {
                    isEditing = false;
                    _controller2.text = getDisplayString(_value);
                  });
                }
              }
            },
            focusNode: focusNode,
            onSaved: (value) {
              if (value != null) {
                T? parsedValue;
                if (T == int) {
                  parsedValue = int.tryParse(value) as T?;
                } else if (T == double) {
                  parsedValue = double.tryParse(value) as T?;
                } else {
                  parsedValue = value as T?;
                }
                if (parsedValue != null) {
                  widget.onUpdate(parsedValue, widget.fieldName);
                  _value = parsedValue;

                  setState(() {
                    isEditing = false;
                    _controller2.text = getDisplayString(_value);
                  });
                }
              }
            },
            decoration: InputDecoration(
              labelText: widget.fieldName.toTitleCase(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {
                  _formKey.currentState!.save();
                  setState(() {
                    isEditing = false;
                  });
                },
              ),
            ),
          ),
        ),
      ),

      secondChild: TextFormField(
        controller: _controller2,
        readOnly: true,

        decoration: InputDecoration(
          labelText: widget.fieldName.toTitleCase(),
          suffixIcon: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // _formKey.currentState!.save();
              setState(() {
                isEditing = true;
                Future.delayed(Duration(milliseconds: 500), () {
                  focusNode.requestFocus();
                });

                // _controller.selection = TextSelection.collapsed(
                //   offset: _controller.text.length,
                // );
              });
            },
          ),
        ),
      ),

      // secondChild: Column(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     Text(
      //       widget.fieldName.toTitleCase(),
      //       style: Theme.of(context).textTheme.labelSmall,
      //     ),
      //     Row(
      //       children: [
      //         displayWidget,
      //         IconButton(
      //           icon: const Icon(Icons.edit),
      //           onPressed: () {
      //             setState(() {
      //               isEditing = true;
      //             });
      //           },
      //         ),
      //       ],
      //     ),
      //   ],
      // ),
      crossFadeState: isEditing
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 300),
    );
  }
}
