import 'package:flutter/material.dart';

import '../widgets/labeled_text.dart';

class LightLabel extends StatelessWidget {
  final String text;
  final LabelPosition position;
  const LightLabel({
    Key? key,
    required this.text,
    this.position = LabelPosition.right,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: position == LabelPosition.right
          ? TextAlign.right
          : TextAlign.left,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
      ),
    );
  }
}
