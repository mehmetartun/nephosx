import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import '../../../model/drink.dart';
import '../../../model/enums.dart';

class DrinksListView extends StatelessWidget {
  final List<Drink> drinks;
  final void Function() refresh;
  final void Function() exportCSV;
  final void Function(Drink drink) drinkSelected;
  const DrinksListView({
    super.key,
    required this.refresh,
    required this.drinks,
    required this.exportCSV,
    required this.drinkSelected,
  });

  List<Widget> _buildDrinksList(
    DrinkType drinkType,
    List<Drink> drinks,
    context,
  ) {
    List<Widget> temp = drinks
        .where((drink) {
          return drink.drinkType == drinkType;
        })
        .toList()
        .map((drink) {
          return ListTile(
                // Decode the base64 string into a Uint8List for Image.memory
                leading: Image.memory(base64Decode(drink.imageBase64)),
                title: Text(drink.name),
                // subtitle: Text(drink.servingFormatString),
                onTap: () {
                  drinkSelected(drink);
                },
                trailing:
                    (drink.drinkType == DrinkType.cocktail &&
                            drink.cocktailRecipe != null) ||
                        (drink.drinkInfo != null &&
                            drink.drinkType != DrinkType.cocktail)
                    ? Icon(Icons.check)
                    : Icon(Icons.close),
              )
              as Widget;
        })
        .toList();
    temp.insert(
      0,
      Text(
        drinkType.name.toUpperCase(),
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
    temp.add(SizedBox(height: 20));
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drink List'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: refresh),
          IconButton(icon: Icon(Icons.download), onPressed: exportCSV),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ..._buildDrinksList(DrinkType.beer, drinks, context),
              ..._buildDrinksList(DrinkType.cocktail, drinks, context),
              ..._buildDrinksList(DrinkType.spirit, drinks, context),
              ..._buildDrinksList(DrinkType.wine, drinks, context),
              ..._buildDrinksList(DrinkType.cider, drinks, context),
              ..._buildDrinksList(DrinkType.bubbly, drinks, context),
            ],
          ),
        ),
      ),
    );
  }
}
