import 'package:flutter/material.dart';

class AdminOnboardingErrorView extends StatelessWidget {
  const AdminOnboardingErrorView({
    Key? key,
    required this.message,
    required this.onCancel,
  }) : super(key: key);

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
