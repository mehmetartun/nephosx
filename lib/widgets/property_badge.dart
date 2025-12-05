import 'package:flutter/material.dart';

class PropertyBadge extends StatelessWidget {
  const PropertyBadge({
    super.key,
    required this.text,
    this.textStyle,
    this.backgroundColor,
    this.foregroundColor,
    this.icon,
  });
  final String text;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color:
            backgroundColor ?? Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Text(
        text,
        style:
            textStyle ??
            Theme.of(context).textTheme.bodySmall?.copyWith(
              color:
                  foregroundColor ??
                  Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
