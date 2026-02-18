import 'package:flutter/material.dart';

class Descriptor extends StatelessWidget {
  const Descriptor({
    super.key,
    required this.label,
    required this.text,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
    this.gap = 0,
  });
  final String label;
  final String text;
  final EdgeInsets padding;
  final double gap;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: textTheme.labelMedium),
          SizedBox(height: gap),
          Text(text, style: textTheme.bodyLarge),
        ],
      ),
    );
  }
}
