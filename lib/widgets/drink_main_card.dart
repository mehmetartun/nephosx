import 'package:coach/extensions/capitalize.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/drink.dart';
import '../model/enums.dart';
import '../services/image_utils.dart';
import 'drink_card.dart';
import 'edit_property.dart';

class DrinkMainCard extends StatefulWidget {
  const DrinkMainCard({
    super.key,
    required this.drink,
    required this.onUpdate,
    required this.runRecipe,
    required this.runDrink,
  });
  final Future<Map<String, dynamic>> Function(String) runRecipe;
  final void Function<T>(T, String) onUpdate;
  final Future<Map<String, dynamic>> Function(String) runDrink;

  final Drink drink;

  @override
  State<DrinkMainCard> createState() => _DrinkMainCardState();
}

class _DrinkMainCardState extends State<DrinkMainCard> {
  Map<String, dynamic>? result;
  bool isGenerating = false;
  late Widget imageWidget;

  @override
  void initState() {
    super.initState();
    imageWidget = Image.memory(
      width: 150,
      ImageUtils.parseBase64Image(widget.drink.imageBase64)!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.drink.cocktailRecipe == null) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.drink.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 4),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                    ),
                    child: imageWidget,
                  ),
                ],
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Serving Format",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),

                    // Text(
                    //   widget.drink.servingFormatString.toTitleCase(),
                    //   style: Theme.of(context).textTheme.titleMedium,
                    // ),
                    SizedBox(height: 5),
                    Text(
                      "Serving Size",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),

                    // Text(
                    //   NumberFormat(
                    //     '0 mL',
                    //     'en_US',
                    //   ).format(widget.drink.servingVolumeInMl),
                    //   style: Theme.of(context).textTheme.titleMedium,
                    // ),
                    SizedBox(height: 5),
                    Text(
                      "Alcohol",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),

                    // Text(
                    //   NumberFormat(
                    //     "0.0 '%",
                    //     'en_US',
                    //   ).format(widget.drink.alcoholPercentage),
                    //   style: Theme.of(context).textTheme.titleMedium,
                    // ),
                  ],
                ),
              ),
            ],
          ),
          FilledButton(child: Text("Run Drink"), onPressed: () async {}),
          // EditProperty(
          //   fieldName: 'Serving',
          //   initialValue: widget.drink.servingVolumeInMl,
          //   onUpdate: (value, fieldName) =>
          //       widget.onUpdate<double>(value, fieldName),
          //   numberFormat: NumberFormat('0 mL', 'en_US'),
          // ),
          // EditProperty(
          //   fieldName: 'ABV%',
          //   initialValue: widget.drink.alcoholPercentage,
          //   onUpdate: (value, fieldName) =>
          //       widget.onUpdate<double>(value, fieldName),
          //   numberFormat: NumberFormat("0.0 '%", 'en_US'),
          // ),
          EditProperty(
            fieldName: 'Name',
            initialValue: widget.drink.name,
            onUpdate: (value, fieldName) =>
                widget.onUpdate<String>(value, fieldName),
          ),
          // EditProperty(
          //   fieldName: 'Description',
          //   initialValue: widget.drink.description,
          //   onUpdate: (value, fieldName) =>
          //       widget.onUpdate<String>(value, fieldName),
          // ),
        ],

        if (widget.drink.cocktailRecipe == null &&
            widget.drink.drinkType == DrinkType.cocktail)
          FilledButton(
            onPressed: isGenerating
                ? null
                : () async {
                    setState(() {
                      isGenerating = true;
                    });
                    result = await widget.runRecipe(widget.drink.name);
                    setState(() {
                      isGenerating = false;
                    });
                  },
            child: Text("Get Recipe"),
          ),

        // if (widget.drink.cocktailRecipe != null) ...[
        //   DrinkCard(drink: widget.drink, showTitle: true),
        // ],
        DrinkCard(drink: widget.drink, showTitle: true),
        //
      ],
    );
  }
}
