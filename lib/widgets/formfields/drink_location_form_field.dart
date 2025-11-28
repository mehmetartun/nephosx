import 'package:coach/model/drink.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../extensions/capitalize.dart';
import '../../model/enums.dart';
import '../../services/responsive_utils.dart';

class DrinkLocationFormField extends FormField<DrinkLocation> {
  DrinkLocationFormField({
    super.key,
    super.validator,
    super.onSaved,
    super.initialValue,
    EdgeInsets? padding,
  }) : super(
         builder: (state) {
           return _DrinkLocationFormField(
             state: state,
             locationList: DrinkLocation.values,
             padding: padding ?? EdgeInsets.all(16),
           );
         },
       );
}

class _DrinkLocationFormField extends StatefulWidget {
  const _DrinkLocationFormField({
    required this.state,
    required this.locationList,
    required this.padding,
  });
  final FormFieldState<DrinkLocation> state;
  final List<DrinkLocation> locationList;
  final EdgeInsets padding;

  @override
  State<_DrinkLocationFormField> createState() =>
      _DrinkLocationFormFieldState();
}

class _DrinkLocationFormFieldState extends State<_DrinkLocationFormField> {
  DrinkLocation? selectedSize;
  DrinkLocation? initialValue;
  @override
  void initState() {
    super.initState();
    selectedSize = widget.state.value;
    initialValue = widget.state.value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.state.hasError) ...[
          Text(
            widget.state.errorText ?? "",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          SizedBox(height: 10),
        ],
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: widget.padding,
          // Use the crossAxisCount to configure the grid delegate
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ScreenUtils.getGridCount(context),
            crossAxisSpacing: 10.0, // Spacing between columns
            mainAxisSpacing: 10.0, // Spacing between rows
            childAspectRatio: 2, // This is the key to making them square
          ),
          itemCount: widget.locationList.length,
          itemBuilder: (context, index) {
            // Your button widget goes here
            return GestureDetector(
              onTap: () {
                // widget.onAmountSelected(widget.drink, sizes[index]);
                setState(() {
                  selectedSize = widget.locationList[index];
                  widget.state.didChange(selectedSize);
                });
              },
              child: Container(
                padding: EdgeInsets.all(10),

                decoration: ShapeDecoration(
                  color: selectedSize == widget.locationList[index]
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
                      child: Text(
                        widget.locationList[index].title.toTitleCase(),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: selectedSize == widget.locationList[index]
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    // Align(
                    //   alignment: Alignment.bottomRight,
                    //   child: Column(
                    //     mainAxisSize: MainAxisSize.min,
                    //     children: [
                    //       Text(
                    //         NumberFormat(
                    //           '0 mL',
                    //         ).format(widget.locations[index].volumeInML),
                    //         style: Theme.of(context).textTheme.titleMedium
                    //             ?.copyWith(
                    //               color: selectedSize == widget.sizes[index]
                    //                   ? Theme.of(context).colorScheme.onPrimary
                    //                   : Theme.of(context).colorScheme.primary,
                    //             ),
                    //       ),
                    //       Text(
                    //         NumberFormat(
                    //           '0.0 oz',
                    //         ).format((widget.sizes[index].volumeInML.mLtoOz())),
                    //         style: Theme.of(context).textTheme.titleMedium
                    //             ?.copyWith(
                    //               color: selectedSize == widget.sizes[index]
                    //                   ? Theme.of(context).colorScheme.onPrimary
                    //                   : Theme.of(context).colorScheme.primary,
                    //             ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
