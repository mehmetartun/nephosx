import 'package:flutter/material.dart';
import 'package:nephosx/constants.dart';
import 'package:responsive_framework/responsive_framework.dart';

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
      appBar: AppBar(title: Text("Error"), centerTitle: true),

      body: MaxWidthBox(
        alignment: Alignment.topLeft,
        maxWidth: 600,
        child: Padding(
          padding: kColumnPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message),
              SizedBox(height: 10),
              FilledButton(onPressed: onCancel, child: Text("Back")),
            ],
          ),
        ),
      ),
    );
  }
}
