import 'package:flutter/material.dart';

import '../../../model/drink.dart';
import '../../../widgets/drink_card.dart';

class DrinkView2 extends StatelessWidget {
  const DrinkView2({super.key, required this.drink});
  final Drink drink;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(drink.name)),
      body: SingleChildScrollView(
        child: DrinkCard(drink: drink, showTitle: false),
      ),
    );
  }
}
