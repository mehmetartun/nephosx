import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

import '../model/light_label.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum LabelPosition { left, right }

class LabeledText<T> extends StatelessWidget {
  const LabeledText({
    super.key,
    required this.value,
    this.format,
    required this.label,
    this.position = LabelPosition.right,
  });
  final T value;
  final String? format;
  final String label;
  final LabelPosition? position;

  @override
  Widget build(BuildContext context) {
    String text;
    if ((value is double || value is int) && format != null) {
      // The value is a number and a format is provided.
      text = NumberFormat(format).format(value);
    } else if (value is DateTime && format != null) {
      text = DateFormat(format).format(value as DateTime);
    } else {
      text = value.toString();
    }

    return Column(
      crossAxisAlignment: position == LabelPosition.left
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        LightLabel(text: label, position: position!),
        Text(text, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}
