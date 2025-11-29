import 'dart:async';
import 'dart:convert';

import 'package:nephosx/extensions/capitalize.dart';
import 'package:nephosx/model/drink.dart';
import 'package:nephosx/pages/consumption_entry/cubit/consumption_entry_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../model/enums.dart';
import 'drink_card.dart';
import 'drink_info_button.dart';

class SelectionButtonDrink extends StatefulWidget {
  const SelectionButtonDrink({
    super.key,
    required this.onDrinkSelected,
    required this.drink,
    required this.selected,
  });
  final void Function(Drink, bool) onDrinkSelected;
  final Drink drink;
  final bool selected;

  @override
  State<SelectionButtonDrink> createState() => _SelectionButtonDrinkState();
}

class _SelectionButtonDrinkState extends State<SelectionButtonDrink> {
  // String getImagePath(DrinkType drinkType) {
  //   switch (drinkType) {
  //     case DrinkType.beer:
  //       return "assets/images2/BeerPaleAle.png";
  //     case DrinkType.cider:
  //       return "assets/images3/AppleCider.png";
  //     case DrinkType.cocktail:
  //       return "assets/images2/PornstarMartini.png";
  //     case DrinkType.spirit:
  //       return "assets/images2/Whisky.png";
  //     case DrinkType.wine:
  //       return "assets/images2/WineRed.png";
  //     case DrinkType.bubbly:
  //       return "assets/images2/ProseccoWhite.png";
  //   }
  // }

  late bool _selected;
  late StreamSubscription<ConsumptionEntryState> _subscription;
  late Widget imageWidget;
  @override
  void initState() {
    super.initState();
    imageWidget = Image.memory(
      base64Decode(widget.drink.imageBase64),
      width: 50,
    );
    _selected = widget.selected;
    _subscription = context.read<ConsumptionEntryCubit>().stream.listen((
      state,
    ) {
      if (state is ConsumptionEntryForDrinkType) {
        if (widget.drink == state.selectedDrink) {
        } else {
          if (_selected) {
            setState(() {
              _selected = false;
            });
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selected = !_selected;
        });
        widget.onDrinkSelected(widget.drink, _selected);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        padding: EdgeInsets.all(10),
        decoration: ShapeDecoration(
          color: _selected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHigh,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                widget.drink.name.toTitleCase(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: _selected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            Align(alignment: Alignment.bottomRight, child: imageWidget),
            // Align(
            //   alignment: Alignment.topRight,
            //   child: DrinkInfoButton(drink: widget.drink),
            // ),
          ],
        ),
      ),
    );
  }
}
