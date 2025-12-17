import 'package:flutter/material.dart';

class ListingErrorView extends StatelessWidget {
  const ListingErrorView({
    super.key,
    required this.message,
    required this.onCancel,
  });

  final String message;
  final void Function() onCancel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("Error"),
          Text(message),
          TextButton(onPressed: onCancel, child: Text("Back")),
        ],
      ),
    );
  }
}
