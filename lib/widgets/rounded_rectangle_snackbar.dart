import 'package:flutter/material.dart';

class RoundedRectangleSnackbar extends StatelessWidget {
  const RoundedRectangleSnackbar(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(text),
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
