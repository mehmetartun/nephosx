import 'package:nephosx/widgets/annotated_list_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/drink.dart';
import '../model/enums.dart';
import '../services/image_utils.dart';
import 'expanding_text.dart';
import 'labeled_text.dart';

class DrinkCard extends StatefulWidget {
  const DrinkCard({super.key, required this.drink, this.showTitle = true});
  final Drink drink;
  final bool showTitle;

  @override
  State<DrinkCard> createState() => _DrinkCardState();
}

class _DrinkCardState extends State<DrinkCard> {
  bool isCocktail = false;
  bool isDrink = false;
  int? historyMaxLines = 1;
  TextOverflow? historyOverflow = TextOverflow.ellipsis;
  late Widget imageWidget;
  @override
  void initState() {
    super.initState();
    if (widget.drink.cocktailRecipe == null) {
      isCocktail = false;
    } else {
      isCocktail = true;
    }
    if (widget.drink.drinkInfo == null) {
      isDrink = false;
    } else {
      isDrink = true;
    }

    imageWidget = Image.memory(
      ImageUtils.parseBase64Image(widget.drink.imageBase64)!,
    );
  }

  void toggleHistory() {
    setState(() {
      if (historyMaxLines == 1) {
        historyMaxLines = null;
        historyOverflow = null;
      } else {
        historyMaxLines = 1;
        historyOverflow = TextOverflow.ellipsis;
      }
    });
  }

  Widget _theDrink() {
    return isDrink
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.showTitle)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    widget.drink.drinkInfo!.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      clipBehavior: Clip.hardEdge,
                      padding: EdgeInsets.all(20),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                      ),
                      child: imageWidget,
                    ),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    flex: 1,
                    child: Container(
                      child: Wrap(
                        spacing: 20,
                        runSpacing: 10,
                        children: [
                          // LabeledText(
                          //   value: widget.drink.cocktailRecipe!.alcoholUnits,
                          //   format: '0.0',
                          //   label: "Units",
                          //   position: LabelPosition.right,
                          // ),
                          LabeledText(
                            value: widget.drink.drinkInfo!.servingSizeInMl,
                            format: '0 mL',
                            label: "Serving",
                            position: LabelPosition.right,
                          ),

                          LabeledText(
                            value: widget
                                .drink
                                .drinkInfo!
                                .alcoholByVolumePercentage,
                            format: "0.0 '%",
                            label: "ABV%",
                            position: LabelPosition.right,
                          ),

                          LabeledText(
                            value: widget
                                .drink
                                .drinkInfo!
                                .caloriesPerServingInKCal,
                            format: "0 kCal",
                            label: "Calories",
                            position: LabelPosition.right,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                widget.drink.drinkInfo!.servingFormat,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 10),
              ExpandingText(
                title: 'History',
                text: widget.drink.drinkInfo!.history,
              ),
              SizedBox(height: 10),
              Text(
                "Ingredients",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              ...widget.drink.drinkInfo!.productionIngredients.map((
                ingredient,
              ) {
                // return Row(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     // Text(
                //     //   ingredient.quantityInMl == 0
                //     //       ? ""
                //     //       : NumberFormat(
                //     //           "0 mL  ",
                //     //           'en_US',
                //     //         ).format(ingredient.quantityInMl),
                //     // ),
                //     Text(
                //       ingredient.name,
                //       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //     SizedBox(width: 5),
                //     Text(ingredient.description),
                //   ],
                // );
                return Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: AnnotatedListText(
                    label: ingredient.name,
                    text: ingredient.description,
                  ),
                );
              }),
              // SizedBox(height: 10),
              // Text(
              //   "Preparation",
              //   style: Theme.of(context).textTheme.headlineSmall,
              // ),
              // ...widget.drink.cocktailRecipe!.instructions.map((instruction) {
              //   return Padding(
              //     padding: const EdgeInsets.only(bottom: 10.0),
              //     child: Row(
              //       crossAxisAlignment: CrossAxisAlignment.baseline,
              //       textBaseline: TextBaseline.alphabetic,

              //       children: [
              //         Container(
              //           padding: EdgeInsets.fromLTRB(7, 2, 7, 2),
              //           decoration: ShapeDecoration(
              //             color: Theme.of(
              //               context,
              //             ).colorScheme.secondaryContainer,
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(5),
              //             ),
              //           ),
              //           child: Text(
              //             instruction.step == 0
              //                 ? ""
              //                 : NumberFormat(
              //                     "0",
              //                     'en_US',
              //                   ).format(instruction.step),
              //             style: Theme.of(context).textTheme.bodySmall
              //                 ?.copyWith(
              //                   color: Theme.of(
              //                     context,
              //                   ).colorScheme.onSecondaryContainer,
              //                   fontWeight: FontWeight.bold,
              //                 ),
              //           ),
              //         ),
              //         SizedBox(width: 10),
              //         Expanded(
              //           child: Text(
              //             instruction.description,
              //             style: Theme.of(context).textTheme.bodyMedium,
              //           ),
              //         ),
              //       ],
              //     ),
              //   );
              // }).toList(),
            ],
          )
        : Container();
  }

  Widget _theCocktail() {
    return isCocktail
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.showTitle)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    widget.drink.cocktailRecipe!.cocktailName,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      clipBehavior: Clip.hardEdge,
                      padding: EdgeInsets.all(20),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                      ),
                      child: imageWidget,
                    ),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    flex: 1,
                    child: Container(
                      child: Wrap(
                        spacing: 20,
                        runSpacing: 10,
                        children: [
                          LabeledText(
                            value: widget.drink.cocktailRecipe!.alcoholUnits,
                            format: '0.0',
                            label: "Units",
                            position: LabelPosition.right,
                          ),
                          LabeledText(
                            value: widget.drink.cocktailRecipe!.totalVolume,
                            format: '0 mL',
                            label: "Serving",
                            position: LabelPosition.right,
                          ),

                          LabeledText(
                            value: widget
                                .drink
                                .cocktailRecipe!
                                .alcoholByVolumePercent,
                            format: "0.0 '%",
                            label: "ABV%",
                            position: LabelPosition.right,
                          ),

                          LabeledText(
                            value: widget.drink.cocktailRecipe!.totalCalories,
                            format: "0 kCal",
                            label: "Calories",
                            position: LabelPosition.right,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                widget.drink.cocktailRecipe!.servingFormat,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 10),
              ExpandingText(
                title: 'History',
                text: widget.drink.cocktailRecipe!.history,
              ),
              SizedBox(height: 10),
              Text(
                "Ingredients",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              ...widget.drink.cocktailRecipe!.ingredients.map((ingredient) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ingredient.quantityInMl == 0
                          ? ""
                          : NumberFormat(
                              "0 mL  ",
                              'en_US',
                            ).format(ingredient.quantityInMl),
                    ),
                    Text(ingredient.name),
                  ],
                );
              }),
              SizedBox(height: 10),
              Text(
                "Preparation",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              ...widget.drink.cocktailRecipe!.instructions.map((instruction) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,

                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(7, 2, 7, 2),
                        decoration: ShapeDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.secondaryContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Text(
                          instruction.step == 0
                              ? ""
                              : NumberFormat(
                                  "0",
                                  'en_US',
                                ).format(instruction.step),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSecondaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          instruction.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return widget.drink.drinkType == DrinkType.cocktail
        ? _theCocktail()
        : _theDrink();
  }
}
