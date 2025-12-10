import 'package:flutter/material.dart';

class CorpAdminUsersErrorView extends StatelessWidget {
  const CorpAdminUsersErrorView({
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
