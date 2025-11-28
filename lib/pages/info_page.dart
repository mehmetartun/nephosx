import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key, this.title, this.content});
  final String? title;
  final String? content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title ?? 'Info Page')),
      body: Center(
        child: Column(
          children: [
            Text(content ?? 'This is the Info Page'),
            Text(GoRouter.of(context).state.uri.toString()),
          ],
        ),
      ),
    );
  }
}
