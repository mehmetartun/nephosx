import 'package:flutter/material.dart';

import 'animation_widget.dart';

class SpashScreenNew extends StatelessWidget {
  const SpashScreenNew({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ComputerGridAnimation(),
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
      ),
    );
  }
}
