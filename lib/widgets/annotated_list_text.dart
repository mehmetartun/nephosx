import 'package:flutter/material.dart';

class AnnotatedListText extends StatelessWidget {
  const AnnotatedListText({super.key, required this.label, required this.text});
  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: label,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        children: <TextSpan>[
          TextSpan(text: ' ', style: Theme.of(context).textTheme.bodyMedium),
          TextSpan(text: text, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
