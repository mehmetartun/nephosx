import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../model/drink.dart';
import 'drink_card.dart';

class DrinkInfoButton extends StatelessWidget {
  const DrinkInfoButton({super.key, required this.drink});
  final Drink drink;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.info),
      onPressed: () async {
        await showDialog(
          context: context,
          builder: (context) => MaxWidthBox(
            maxWidth: 500,
            child: Dialog(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: DrinkCard(drink: drink),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
