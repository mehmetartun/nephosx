import 'package:flutter/material.dart';

class CorpUserAcceptanceLoadingView extends StatelessWidget {
  final String title;
  final String? message;
  const CorpUserAcceptanceLoadingView({
    super.key,
    required this.title,
    this.message = "Loading...",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message ?? "Loading..."),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
