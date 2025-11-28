import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ScreenUtils {
  static int getGridCount(BuildContext context) {
    return ResponsiveValue<int>(
      context,
      conditionalValues: [
        const Condition.equals(name: MOBILE, value: 3),
        const Condition.equals(name: TABLET, value: 4),
        const Condition.equals(name: DESKTOP, value: 6),
        const Condition.equals(name: '4K', value: 8),
      ],
    ).value;
  }
}
