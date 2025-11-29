import 'package:nephosx/extensions/capitalize.dart';
import 'package:nephosx/pages/consumption_entry/cubit/consumption_entry_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/enums.dart';

class SelectionButton extends StatefulWidget {
  const SelectionButton({
    super.key,
    required this.onDrinkTypeSelected,
    required this.drinkType,
    required this.selected,
  });
  final void Function(DrinkType, bool) onDrinkTypeSelected;
  final DrinkType drinkType;
  final bool selected;

  @override
  State<SelectionButton> createState() => _SelectionButtonState();
}

class _SelectionButtonState extends State<SelectionButton> {
  String getImagePath(DrinkType drinkType) {
    switch (drinkType) {
      case DrinkType.beer:
        return "assets/images2/BeerPaleAle.png";
      case DrinkType.cider:
        return "assets/images3/AppleCider.png";
      case DrinkType.cocktail:
        return "assets/images2/PornstarMartini.png";
      case DrinkType.spirit:
        return "assets/images2/Whisky.png";
      case DrinkType.wine:
        return "assets/images2/WineRed.png";
      case DrinkType.bubbly:
        return "assets/images2/ProseccoWhite.png";
    }
  }

  late bool _selected;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConsumptionEntryCubit, ConsumptionEntryState>(
      listenWhen: (previous, current) {
        if (current is ConsumptionEntrySelect) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        if (widget.drinkType == (state as ConsumptionEntrySelect).drinkType) {
          // setState(() {
          //   _selected = true;
          // });
        } else {
          if (_selected) {
            setState(() {
              _selected = false;
            });
          }
        }
      },
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selected = !_selected;
          });
          widget.onDrinkTypeSelected(widget.drinkType, _selected);
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
                  widget.drinkType.name.toTitleCase(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: _selected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Image.asset(getImagePath(widget.drinkType), width: 40),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
