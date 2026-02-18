import 'package:flutter/material.dart';

import '../constants.dart';

class RoundedContainer extends Container {
  RoundedContainer({super.key, super.child, this.containerColor});
  final Color? containerColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kBorderRadius),
        color: containerColor,
      ),
      child: child,
    );
  }
}
