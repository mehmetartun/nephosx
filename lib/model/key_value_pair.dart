import 'package:flutter/material.dart';

class KeyValuePair {
  final String key;
  final String value;
  final Widget? keyWidget;
  final Widget? valueWidget;

  final Function()? onTap;

  KeyValuePair({
    this.key = "Key",
    this.value = "Value",
    this.onTap,
    this.keyWidget,
    this.valueWidget,
  });
}
