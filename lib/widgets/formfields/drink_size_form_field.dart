import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../extensions/capitalize.dart';
import '../../model/enums.dart';
import '../../services/responsive_utils.dart';

class DrinkSizeFormField extends FormField<DrinkSize> {
  final DrinkType drinkType;
  DrinkSizeFormField({
    super.key,
    super.validator,
    super.onSaved,
    super.initialValue,
    required this.drinkType,
  }) : super(
         builder: (state) {
           return _DrinkSizeFormField(
             state: state,
             sizes: DrinkSize.values.where((val) {
               return val.drinkTypes.contains(drinkType);
             }).toList(),
           );
         },
       );
}

class _DrinkSizeFormField extends StatefulWidget {
  const _DrinkSizeFormField({required this.state, required this.sizes});
  final FormFieldState<DrinkSize> state;
  final List<DrinkSize> sizes;

  @override
  State<_DrinkSizeFormField> createState() => __DrinkSizeFormFieldState();
}

class __DrinkSizeFormFieldState extends State<_DrinkSizeFormField> {
  DrinkSize? selectedSize;
  DrinkSize? initialValue;
  @override
  void initState() {
    super.initState();
    selectedSize = widget.state.value;
    initialValue = widget.state.value;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      // Use the crossAxisCount to configure the grid delegate
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ScreenUtils.getGridCount(context),
        crossAxisSpacing: 10.0, // Spacing between columns
        mainAxisSpacing: 10.0, // Spacing between rows
        childAspectRatio: 1.0, // This is the key to making them square
      ),
      itemCount: widget.sizes.length,
      itemBuilder: (context, index) {
        // Your button widget goes here
        return GestureDetector(
          onTap: () {
            // widget.onAmountSelected(widget.drink, sizes[index]);
            setState(() {
              selectedSize = widget.sizes[index];
              widget.state.didChange(selectedSize);
            });
          },
          child: Container(
            padding: EdgeInsets.all(10),

            decoration: ShapeDecoration(
              color: selectedSize == widget.sizes[index]
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.primaryContainer,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: FittedBox(
                    child: Text(
                      widget.sizes[index].description,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: selectedSize == widget.sizes[index]
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        NumberFormat(
                          '0 mL',
                        ).format(widget.sizes[index].volumeInML),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: selectedSize == widget.sizes[index]
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      Text(
                        NumberFormat(
                          '0.0 oz',
                        ).format((widget.sizes[index].volumeInML.mLtoOz())),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: selectedSize == widget.sizes[index]
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
