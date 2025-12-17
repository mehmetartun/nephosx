import 'package:flutter/material.dart';

class AdminOnboardingErrorView extends StatelessWidget {
  const AdminOnboardingErrorView({
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
