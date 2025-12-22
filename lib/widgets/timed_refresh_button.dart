import 'dart:async';

import 'package:flutter/material.dart';

import '../services/duration_utils.dart';

class TimedRefreshButton extends StatefulWidget {
  const TimedRefreshButton({super.key, required this.onRefresh});
  final void Function() onRefresh;

  @override
  State<TimedRefreshButton> createState() => _TimedRefreshButtonState();
}

class _TimedRefreshButtonState extends State<TimedRefreshButton> {
  late String text;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    DateTime initialTime = DateTime.now();
    text = DurationUtils.ago(initialTime);
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        text = DurationUtils.ago(initialTime);
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Last Update $text"),
        SizedBox(width: 10),
        IconButton(icon: Icon(Icons.refresh), onPressed: widget.onRefresh),
      ],
    );
  }
}
