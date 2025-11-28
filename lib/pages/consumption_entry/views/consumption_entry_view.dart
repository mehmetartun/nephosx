import 'dart:convert';

import 'package:coach/model/drink.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../model/enums.dart';
import '../../../services/responsive_utils.dart';
import '../../../widgets/selection_button_drink.dart';

class ConsumptionEntryView extends StatefulWidget {
  const ConsumptionEntryView({
    super.key,
    required this.drinkType,
    required this.drinks,
    required this.onDrinkSelected,

    required this.onCancel,
    required this.onDrinkConfirmed,
  });
  final DrinkType drinkType;
  final List<Drink> drinks;
  final void Function(Drink) onDrinkSelected;
  final void Function(Drink) onDrinkConfirmed;
  final void Function() onCancel;

  @override
  State<ConsumptionEntryView> createState() => _ConsumptionEntryViewState();
}

class _ConsumptionEntryViewState extends State<ConsumptionEntryView> {
  Drink? _drink;

  String getImage(DrinkType type) {
    switch (type) {
      case DrinkType.bubbly:
        return "assets/images/ChampagneImage.jpg";
      case DrinkType.beer:
        return "assets/images/BeerServingImage.jpg";
      case DrinkType.cider:
        return "assets/images/AppleCiderImage.jpg";
      case DrinkType.cocktail:
        return "assets/images/CocktailImage.jpg";
      case DrinkType.wine:
        return "assets/images/WineImage.jpg";
      case DrinkType.spirit:
        return "assets/images/WhiskeyImage.jpg";
      default:
        return "assets/images/BarImage.jpg";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _drink == null
          ? null
          : FloatingActionButton.extended(
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              backgroundColor: Theme.of(context).colorScheme.primary,
              onPressed: () {
                widget.onDrinkConfirmed(_drink!);
              },
              label: Text(_drink?.name ?? ""),
              icon: Icon(Icons.arrow_forward),
              disabledElevation: 10,
              isExtended: true,
            ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            backgroundColor: Colors.black54,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "Drink Diary",
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(color: Colors.white),
              ),
              background: DecoratedBox(
                position: DecorationPosition.foreground,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black54,
                      Colors.transparent,
                      Colors.black54,
                    ],
                    stops: [0.0, 0.2, 1.0],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Image.asset(
                  getImage(widget.drinkType),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            actions: [
              IconButton(icon: Icon(Icons.close), onPressed: widget.onCancel),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 100.0),
            sliver: SliverGrid.builder(
              // padding: const EdgeInsets.all(20.0),
              // shrinkWrap: true,
              // Use the crossAxisCount to configure the grid delegate
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ScreenUtils.getGridCount(context),
                crossAxisSpacing: 15.0, // Spacing between columns
                mainAxisSpacing: 15.0, // Spacing between rows
                childAspectRatio: 1.0, // This is the key to making them square
              ),
              itemCount: widget.drinks.length,
              itemBuilder: (context, index) {
                // Your button widget goes here
                return VisibilityDetector(
                  key: ValueKey(index),
                  onVisibilityChanged: (info) {
                    if (_drink == widget.drinks[index]) {}
                  },
                  child: SelectionButtonDrink(
                    onDrinkSelected: (type, se) {
                      setState(() {
                        if (se) {
                          _drink = type;
                        } else {
                          _drink = null;
                        }
                      });
                      widget.onDrinkSelected(type);
                    },

                    drink: widget.drinks[index],
                    selected: widget.drinks[index] == _drink,
                  ),
                );
              },
            ),
          ),

          // SliverToBoxAdapter(
          //   child: Column(
          //     children: [
          //       ...widget.drinks.map((drink) {
          //         return ListTile(
          //           title: Text(drink.name),
          //           leading: Padding(
          //             padding: const EdgeInsets.all(8.0),
          //             child: Image.memory(base64Decode(drink.imageBase64)),
          //           ),
          //           onTap: () {
          //             widget.onDrinkSelected(drink);
          //           },
          //           // trailing:
          //           //     (drink.drinkType == DrinkType.cocktail &&
          //           //             drink.cocktailRecipe != null) ||
          //           //         (drink.drinkInfo != null &&
          //           //             drink.drinkType != DrinkType.cocktail)
          //           //     ? Icon(Icons.check)
          //           //     : Icon(Icons.close),
          //         );
          //       }),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
